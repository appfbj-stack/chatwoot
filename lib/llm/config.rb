require 'ruby_llm'
require 'kairos_agent'
require 'llm_constants'

module Llm::Config
  # Kairós IA: MiniMax-M3 é o modelo padrão do fork.
  # String literal (e não LlmConstants::DEFAULT_MODEL) porque este arquivo é
  # carregado pelo ruby_llm antes do eager_load do lib/ — referenciar a
  # constante aqui causaria NameError no boot.
  DEFAULT_MODEL = 'MiniMax-M3'

  class << self
    def initialized?
      @initialized ||= false
    end

    def initialize!
      return if @initialized

      configure_ruby_llm
      @initialized = true
    end

    def reset!
      @initialized = false
    end

    def with_api_key(api_key, api_base: nil)
      initialize!
      context = RubyLLM.context do |config|
        config.openai_api_key = api_key
        config.openai_api_base = api_base
      end

      yield context
    end

    private

    def configure_ruby_llm
      RubyLLM.configure do |config|
        config.openai_api_key = system_api_key if system_api_key.present?
        config.openai_api_base = "#{openai_endpoint.chomp('/')}/v1" if openai_endpoint.present?
        config.model_registry_file = Rails.root.join('config/llm_models.json').to_s
        config.openai_protocol = :chat_completions
        config.logger = Rails.logger
      end
    end

    def system_api_key
      # Kairós: env var do MiniMax tem precedência sobre o painel.
      ENV[KairosAgent::MINIMAX_KEY_ENV].presence ||
        ENV['MINIMAX_API_KEY'].presence ||
        InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_API_KEY')&.value
    end

    def openai_endpoint
      # Kairós: default é o endpoint do MiniMax (OpenAI-compatible).
      InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_ENDPOINT')&.value.presence ||
        ENV['MINIMAX_API_ENDPOINT'].presence ||
        LlmConstants::MINIMAX_API_ENDPOINT
    end
  end
end
