# Kairos CRM — AiAgents::MinimaxProvider
# Path no clone: app/services/ai_agents/minimax_provider.rb
# Provider custom MiniMax para o agente Kairos (substitui Captain OpenAI)
# Usa a gem `ruby_llm` já presente no Gemfile
class AiAgents::MinimaxProvider
  include RubyLLM::Utils

  def initialize(account: nil, model: nil, system_prompt: nil)
    @account = account
    @model = model || ENV.fetch('KAIROS_AGENT_MODEL', 'minimax-m-2')
    @system_prompt = system_prompt || ENV.fetch(
      'KAIROS_AGENT_SYSTEM_PROMPT',
      'Voce e o agente Kairos, assistente de atendimento da plataforma Kairos CRM.'
    )
    @client = build_client
  end

  # Streaming chat completion
  def chat(messages, tools: [], &block)
    response = @client.chat(
      model: @model,
      messages: build_messages(messages),
      tools: build_tools(tools),
      stream: block_given?,
      &block
    )
    response
  end

  # Embeddings (pgvector)
  def embed(text)
    @client.embed(text, model: 'minimax-embed-1')
  end

  # Resposta direta (sem tools)
  def complete(prompt)
    @client.complete(
      model: @model,
      prompt: prompt,
      system: @system_prompt,
      max_tokens: ENV.fetch('KAIROS_AGENT_MAX_TOKENS', 4096).to_i,
      temperature: ENV.fetch('KAIROS_AGENT_TEMPERATURE', 0.7).to_f
    )
  end

  # Resumo de conversa
  def summarize_conversation(conversation)
    messages = conversation.messages.recent.limit(50).map do |m|
      { role: m.outgoing? ? 'assistant' : 'user', content: m.content.to_s }
    end

    prompt = <<~PROMPT
      Resuma a conversa abaixo em ate 3 paragrafos.
      Identifique: intencao do cliente, tom emocional, resolucao.
      Idioma: portugues brasileiro.

      #{messages.map { |m| "[#{m[:role]}] #{m[:content]}" }.join("\n")}
    PROMPT

    complete(prompt)
  end

  # Sugestao de resposta para o atendente
  def suggest_reply(conversation)
    last_user_msg = conversation.messages.where(message_type: :incoming).last
    return nil unless last_user_msg

    context = conversation.messages.recent.limit(10).map do |m|
      "#{m.outgoing? ? 'Agente' : 'Cliente'}: #{m.content}"
    end.join("\n")

    prompt = <<~PROMPT
      Baseado no historico abaixo, sugira 3 respostas curtas (max 2 linhas cada)
      que o atendente pode enviar. Tom: profissional, acolhedor, em portugues.

      Ultima mensagem do cliente: "#{last_user_msg.content}"

      Historico:
      #{context}
    PROMPT

    complete(prompt)
  end

  # Tools disponiveis (function calling)
  def available_tools
    [
      :buscar_contato,
      :criar_atendimento,
      :transferir_humano,
      :enviar_whatsapp,
      :consultar_pedido,
      :cancelar_atendimento
    ]
  end

  private

  def build_client
    RubyLLM::Client.new(
      provider: :minimax,
      api_key: ENV.fetch('KAIROS_AGENT_API_KEY', nil),
      endpoint: ENV.fetch('KAIROS_AGENT_ENDPOINT', 'https://api.minimax.com/v1'),
      model: @model
    )
  end

  def build_messages(messages)
    [{ role: 'system', content: @system_prompt }] + messages.map do |m|
      { role: m[:role] || 'user', content: m[:content] }
    end
  end

  def build_tools(tools)
    return [] if tools.blank?

    tools.map do |t|
      case t
      when :buscar_contato then tool_buscar_contato
      when :criar_atendimento then tool_criar_atendimento
      when :transferir_humano then tool_transferir_humano
      when :enviar_whatsapp then tool_enviar_whatsapp
      when :consultar_pedido then tool_consultar_pedido
      when :cancelar_atendimento then tool_cancelar_atendimento
      end
    end
  end

  def tool_buscar_contato
    {
      name: 'buscar_contato',
      description: 'Busca um contato pelo telefone, email ou nome',
      parameters: {
        type: 'object',
        properties: {
          query: { type: 'string', description: 'telefone, email ou nome' }
        },
        required: ['query']
      }
    }
  end

  def tool_criar_atendimento
    {
      name: 'criar_atendimento',
      description: 'Cria um novo atendimento (ticket) para um contato',
      parameters: {
        type: 'object',
        properties: {
          contact_id: { type: 'integer' },
          titulo: { type: 'string' },
          descricao: { type: 'string' }
        },
        required: %w[contact_id titulo descricao]
      }
    }
  end

  def tool_transferir_humano
    {
      name: 'transferir_humano',
      description: 'Transfere a conversa para um atendente humano',
      parameters: {
        type: 'object',
        properties: {
          conversation_id: { type: 'integer' },
          motivo: { type: 'string' }
        },
        required: %w[conversation_id motivo]
      }
    }
  end

  def tool_enviar_whatsapp
    {
      name: 'enviar_whatsapp',
      description: 'Envia uma mensagem WhatsApp via Wazapi',
      parameters: {
        type: 'object',
        properties: {
          phone: { type: 'string' },
          message: { type: 'string' }
        },
        required: %w[phone message]
      }
    }
  end

  def tool_consultar_pedido
    {
      name: 'consultar_pedido',
      description: 'Consulta o status de um pedido',
      parameters: {
        type: 'object',
        properties: { order_id: { type: 'string' } },
        required: ['order_id']
      }
    }
  end

  def tool_cancelar_atendimento
    {
      name: 'cancelar_atendimento',
      description: 'Encerra a conversa marcando como resolvida',
      parameters: {
        type: 'object',
        properties: { conversation_id: { type: 'integer' } },
        required: ['conversation_id']
      }
    }
  end
end
