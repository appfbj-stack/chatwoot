# frozen_string_literal: true

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

  module_function

  # Remove o bloco <think>...</think> (inclusive multiplos e nao-fechados).
  # Retorna somente o texto visivel para o cliente.
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