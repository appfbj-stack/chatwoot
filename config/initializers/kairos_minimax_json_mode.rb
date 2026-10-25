# frozen_string_literal: true

require 'json'
require 'ruby_llm'

module Kairos
  # Kairós/MiniMax — output estruturado no dialeto da MiniMax.
  #
  # O ruby_llm sempre envia `response_format: { type: 'json_schema', ... }`
  # (formato strict da OpenAI). A API da MiniMax NÃO implementa json_schema:
  # aceita apenas `{ type: 'json_object' }`. Sem esta adaptação o Captain
  # recebia texto solto ("Olá! ...") e o parse do JSON morria com
  # "unexpected character: 'Olá!' at line 1 column 1".
  #
  # Aqui rebaixamos json_schema -> json_object e injetamos o schema no prompt
  # do sistema, para o modelo devolver o mesmo formato estruturado que o
  # Captain espera (reasoning + response_parts).
  #
  # O hook é RubyLLM::Protocol#render (a classe base de todos os protocolos),
  # porque o provider escolhe a classe de protocolo dinamicamente.
  module MiniMaxJsonMode
    SCHEMA_INSTRUCTION = <<~PROMPT.freeze
      IMPORTANTE: responda EXCLUSIVAMENTE com um objeto JSON válido, sem texto antes ou depois,
      sem bloco de código e sem comentários. O JSON deve seguir este schema:
      %<schema>s
    PROMPT

    def render(messages, **kwargs)
      payload = super
      response_format = payload[:response_format]
      return payload unless response_format.is_a?(Hash) && response_format[:type] == 'json_schema'
      return payload unless minimax_api_base?

      schema = response_format[:json_schema]
      payload[:response_format] = { type: 'json_object' }
      payload[:messages] = inject_schema_instruction(payload[:messages] || messages, schema)
      payload
    end

    private

    def minimax_api_base?
      base = @provider.respond_to?(:api_base) ? @provider.api_base.to_s : ''
      base.include?('minimax')
    end

    def inject_schema_instruction(messages, schema)
      list = Array(messages).map { |message| message.dup }
      instruction = Kernel.format(SCHEMA_INSTRUCTION, schema: JSON.generate(schema[:schema]))
      index = list.index { |message| message[:role].to_s == 'system' }

      if index && list[index][:content].is_a?(String)
        list[index][:content] = "#{list[index][:content]}\n\n#{instruction}"
      else
        list.unshift({ role: 'system', content: instruction })
      end
      list
    end
  end

  # Higiene antes do parse: o MiniMax-M3 pode devolver o raciocínio (<think>)
  # junto do texto ou envolver o JSON em ```json ... ```. O ruby_llm faz
  # JSON.parse cru e quebrava.
  module MiniMaxJsonParse
    def parsed
      return super unless content.is_a?(String)

      cleaned = content.to_s
                    .sub(/\A<think>.*?<\/think>\s*/m, '')
                    .sub(/\A```(?:json)?\s*/i, '')
                    .sub(/```\z/, '')
                    .strip
      @parsed ||= JSON.parse(cleaned)
    rescue JSON::ParserError
      super
    end
  end
end

if defined?(RubyLLM::Protocol)
  RubyLLM::Protocol.prepend(Kairos::MiniMaxJsonMode)
end

if defined?(RubyLLM::Message)
  RubyLLM::Message.prepend(Kairos::MiniMaxJsonParse)
end
