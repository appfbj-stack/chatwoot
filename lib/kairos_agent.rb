# frozen_string_literal: true

require 'json'
require 'net/http'

module KairosAgent
  # Nome da env var que carrega a chave do MiniMax no Kairós CRM.
  # Ordem de resolução (ver config/initializers/ai_agents.rb):
  #   1. KAIROS_AGENT_MINIMAX_API_KEY  (nome explícito do white-label)
  #   2. MINIMAX_API_KEY               (nome generico, evita duplicar env)
  #   3. InstallationConfig CAPTAIN_OPEN_AI_API_KEY (preenchido pelo painel)
  MINIMAX_KEY_ENV = 'KAIROS_AGENT_MINIMAX_API_KEY'

  # Modelos disponiveis na conta MiniMax (testado em 2026-10-21).
  MODELS = {
    'MiniMax-M3' => {
      display_name: 'Kairós M3',
      context_window: 204_800,
      max_output_tokens: 8_192,
      capabilities: %w[function_calling reasoning],
      note: 'Modelo principal. Emite bloco <think>...</think> no content.'
    },
    'MiniMax-M2.5' => {
      display_name: 'Kairós M2.5',
      context_window: 204_800,
      max_output_tokens: 8_192,
      capabilities: %w[function_calling],
      note: 'Alternativa mais barata.'
    }
  }.freeze

  # Prefixo do bloco de raciocinio que o MiniMax prepende no content.
  # A UI/logger do Chatwoot nao renderiza markdown com <think>, entao
  # filtramos antes de persistir a mensagem.
  THINK_OPEN = '<think>'
  THINK_CLOSE = '</think>'

  # ---- Embeddings ----
  # O /v1/embeddings da MiniMax NAO e OpenAI-compatible no nivel do wire:
  #   request  -> { "model": "embo-01", "type": "db" | "query", "texts": [...] }
  #   response -> { "vectors": [[...]], "total_tokens": N }
  # O ruby_llm assume { input: [...] } e { data: [...] } e quebra com nil
  # (undefined method 'length' for nil em parse_embedding_response).
  EMBEDDING_MODEL = 'embo-01'
  EMBEDDING_TYPE_DOCUMENT = 'db'
  EMBEDDING_TYPE_QUERY = 'query'

  module_function

  # Remove o bloco <think>...</think> (inclusive multiplos e nao-fechados).
  # Retorna somente o texto visivel para o cliente.
  # URL do endpoint de embeddings da MiniMax.
  def minimax_embedding_url
    base = InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_ENDPOINT')&.value.presence ||
           ENV['MINIMAX_API_ENDPOINT'].presence ||
           LlmConstants::MINIMAX_API_ENDPOINT
    "#{base.to_s.chomp('/')}/v1/embeddings"
  end

  def minimax_api_key
    ENV[MINIMAX_KEY_ENV].presence || ENV['MINIMAX_API_KEY'].presence ||
      InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_API_KEY')&.value
  end

  # Gera embedding no dialeto nativo da MiniMax.
  # Retorna nil quando o provedor falha (rate limit, quota, etc.) para que o
  # chamador degrade sem derrubar a resposta do Captain.
  def embed(texts, model: EMBEDDING_MODEL, type: EMBEDDING_TYPE_DOCUMENT)
    list = Array(texts).map(&:to_s).reject(&:blank?)
    return nil if list.empty?

    uri = URI(minimax_embedding_url)
    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "Bearer #{minimax_api_key}"
    req.body = { model: model, type: type, texts: list }.to_json

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https',
                          open_timeout: 10, read_timeout: 45) { |http| http.request(req) }
    body = JSON.parse(res.body) rescue {}
    vectors = body['vectors']
    if vectors.blank?
      Rails.logger.error("[KairosAgent] embedding sem vectors: #{body['base_resp'].inspect}")
      return nil
    end

    vectors.first
  rescue StandardError => e
    Rails.logger.error("[KairosAgent] embedding falhou: #{e.message}")
    nil
  end

  def strip_reasoning(content)
    return content if content.nil?

    cleaned = content.dup
    loop do
      start_index = cleaned.index(THINK_OPEN)
      break if start_index.nil?

      end_index = cleaned.index(THINK_CLOSE, start_index)
      if end_index.nil?
        # bloco nao fechado (truncado por max_tokens) — descarta o resto
        cleaned = cleaned[0...start_index]
        break
      end
      cleaned = cleaned[0...start_index] + cleaned[(end_index + THINK_CLOSE.length)..].to_s
    end
    cleaned.strip
  end
end