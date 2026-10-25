class Captain::Llm::EmbeddingService
  include Integrations::LlmInstrumentation

  class EmbeddingsError < StandardError; end

  def initialize(account_id: nil)
    Llm::Config.initialize!
    @account_id = account_id
    @embedding_model = self.class.embedding_model
  end

  def self.embedding_model
    InstallationConfig.find_by(name: 'CAPTAIN_EMBEDDING_MODEL')&.value.presence || LlmConstants::DEFAULT_EMBEDDING_MODEL
  end

  def get_embedding(content, model: @embedding_model)
    return nil if content.blank?

    instrument_embedding_call(instrumentation_params(content, model)) do
      if minimax_provider?
        KairosAgent.embed(content, model: KairosAgent::EMBEDDING_MODEL, type: KairosAgent::EMBEDDING_TYPE_DOCUMENT)
      else
        RubyLLM.embed(content, model: model).vectors
      end
    end
  rescue RubyLLM::Error => e
    Rails.logger.error "Embedding API Error: #{e.message}"
    nil
  rescue StandardError => e
    # Kairós: falha de embedding (rate limit da MiniMax, por exemplo) nao pode
    # derrubar a resposta inteira do Captain. O FAQ semantico simplesmente fica
    # sem resultado e o assistente continua respondendo.
    Rails.logger.error "Embedding Error: #{e.message}"
    nil
  end

  private

  def minimax_provider?
    endpoint = InstallationConfig.find_by(name: 'CAPTAIN_OPEN_AI_ENDPOINT')&.value.to_s
    endpoint.include?('minimax')
  end

  def instrumentation_params(content, model)
    {
      span_name: 'llm.captain.embedding',
      model: model,
      input: content,
      feature_name: 'embedding',
      account_id: @account_id
    }
  end
end
