# Kairos CRM — Routes: add Wazapi webhook
# Path no clone: config/routes.rb (merge into existing routes block)
# Adicionar este bloco:

Rails.application.routes.draw do
  # ... rotas existentes ...

  # Webhooks
  namespace :webhooks do
    # ... existentes ...
    post 'wazapi/:instance_id', to: 'wazapi#process_payload', as: :wazapi_webhook
  end

  # API super admin endpoints
  namespace :api do
    namespace :v1 do
      namespace :accounts do
        # Wazapi inbox setup
        post ':account_id/inboxes/wazapi', to: 'wazapi_inboxes#create'
        get  ':account_id/inboxes/wazapi', to: 'wazapi_inboxes#index'
      end
    end
  end
end
