# frozen_string_literal: true

require 'agents'
require 'kairos_agent'

Rails.application.config.after_initialize do
  # Kairos CRM: MiniMax é o LLM principal. Aceita tanto InstallationConfig
  # (painel) quanto env var MINIMAX_API_KEY / KAIROS_AGENT_MINIMAX_API_KEY.
  api_key = ENV[KairosAgent::MINIMAX_KEY_ENV].presence ||
            ENV['MINIMAX_API_KEY'].presence ||
            InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_API_KEY')&.value
  model = InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_MODEL')&.value.presence || LlmConstants::DEFAULT_MODEL
  api_endpoint = InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_ENDPOINT')&.value ||
                 ENV['MINIMAX_API_ENDPOINT'].presence ||
                 LlmConstants::MINIMAX_API_ENDPOINT

  Agents.configure do |config|
    config.openai_api_key = api_key if api_key.present?
    if api_key.present? && api_endpoint.present?
      api_base = "#{api_endpoint.chomp('/')}/v1"
      config.openai_api_base = api_base
    end
    config.default_model = model
    # MiniMax so expoe /v1/chat/completions (nunca Responses API)
    config.openai_protocol = :chat_completions
    config.model_registry_file = Rails.root.join('config/llm_models.json').to_s
    config.debug = false
  end
rescue StandardError => e
  Rails.logger.error "Failed to configure AI Agents SDK: #{e.message}"
end
