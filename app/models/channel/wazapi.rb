# Kairos CRM — Channel::Wazapi
# Path no clone: app/models/channel/wazapi.rb
# Canal custom para integração com Wazapi WhatsApp API (self-hosted)
class Channel::Wazapi < ApplicationRecord
  self.table_name = 'channel_wazapi'

  validates :phone_number, presence: true
  validates :instance_id, presence: true
  validates :api_token, presence: true

  belongs_to :account
  has_one :inbox, as: :channel, dependent: :destroy_async

  # Wazapi usa webhooks para receber mensagens e API REST para enviar
  # Documentação: https://github.com/wazapilabs/wazapi (placeholder)

  def name
    "Wazapi (#{phone_number})"
  end

  def messaging_window_enabled?
    false
  end

  # Envia mensagem de texto via Wazapi
  def send_text(contact, message)
    return unless api_token.present?

    HTTParty.post(
      "#{base_url}/instances/#{instance_id}/token/#{api_token}/send-text",
      body: {
        phone: contact.phone_number,
        message: message.content
      }.to_json,
      headers: { 'Content-Type' => 'application/json' },
      timeout: wazapi_timeout
    )
  end

  # Envia mensagem com mídia
  def send_attachment(contact, message)
    return unless message.attachments.any?

    attachment = message.attachments.first
    HTTParty.post(
      "#{base_url}/instances/#{instance_id}/token/#{api_token}/send-media",
      body: {
        phone: contact.phone_number,
        caption: message.content,
        mediatype: attachment.file.content_type.start_with?('image/') ? 'image' : 'document',
        media: attachment.file.url,
        fileName: attachment.file.filename.to_s
      }.to_json,
      headers: { 'Content-Type' => 'application/json' },
      timeout: wazapi_timeout
    )
  end

  # Valida assinatura HMAC do webhook
  def self.validate_webhook_signature(payload_body, signature_header, secret)
    return false if signature_header.blank? || secret.blank?

    expected = OpenSSL::HMAC.hexdigest('SHA256', secret, payload_body)
    Rack::Utils.secure_compare(expected, signature_header)
  end

  private

  def base_url
    ENV.fetch('WAZAPI_BASE_URL', 'http://kairos-wazapi:8080')
  end

  def wazapi_timeout
    ENV.fetch('WAZAPI_TIMEOUT', 30).to_i
  end
end
