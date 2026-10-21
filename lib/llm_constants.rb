# frozen_string_literal: true

module LlmConstants
  # Kairos CRM: MiniMax como LLM principal (substitui OpenAI/Captain)
  DEFAULT_MODEL = 'MiniMax-M3'
  DEFAULT_EMBEDDING_MODEL = 'text-embedding-3-small'
  PDF_PROCESSING_MODEL = 'MiniMax-M3'

  OPENAI_API_ENDPOINT = 'https://api.minimax.io'

  MINIMAX_API_ENDPOINT = 'https://api.minimax.io'
  MINIMAX_API_KEY_ENV = 'MINIMAX_API_KEY'

  PROVIDER_PREFIXES = {
    'minimax' => %w[MiniMax- minimax-],
    'openai' => %w[gpt- o1 o3 o4 text-embedding- whisper- tts-],
    'anthropic' => %w[claude-],
    'google' => %w[gemini-],
    'mistral' => %w[mistral- codestral-],
    'deepseek' => %w[deepseek-]
  }.freeze
end
