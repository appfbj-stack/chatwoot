class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include RequestExceptionHandler
  include Pundit::Authorization
  include SwitchLocale
  include TrackSessionActivity

  skip_before_action :verify_authenticity_token

  # Kairos CRM: integracoes externas (Uazapi/Wazapi) mandam o token num header
  # proprio e nao temem sessao Devise. Se nao fizermos esse guard aqui, o
  # DeviseTokenAuth roda antes e devolve 401 antes da API ter chance de ler o token.
  before_action :set_current_user,
                unless: :devise_controller?,
                if: -> { !kairos_external_token_request? }

  # Defined before the before_action above so the guard can call it.
  def kairos_external_token_request?
    respond_to?(:kairos_external_token, true) && kairos_external_token.present?
  end

  def external_token_request?
    kairos_external_token_request?
  end
  around_action :switch_locale
  around_action :handle_with_exception, unless: :devise_controller?

  private

  def set_current_user
    @user ||= current_user
    Current.user = @user
  end

  def pundit_user
    {
      user: Current.user,
      account: Current.account,
      account_user: Current.account_user
    }
  end
end
ApplicationController.include_mod_with('Concerns::ApplicationControllerConcern')
