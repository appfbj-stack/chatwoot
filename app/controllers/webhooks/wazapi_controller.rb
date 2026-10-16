# Kairos CRM — Webhooks::WazapiController
# Path no clone: app/controllers/webhooks/wazapi_controller.rb
# Recebe eventos de mensagens do Wazapi
class Webhooks::WazapiController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def process_payload
    payload = request.body.read
    signature = request.headers['X-Wazapi-Signature']

    channel = find_channel
    return head :unauthorized unless channel
    return head :unauthorized unless Channel::Wazapi.validate_webhook_signature(
      payload, signature, ENV.fetch('WAZAPI_WEBHOOK_SECRET', nil)
    )

    event = JSON.parse(payload)
    handle_event(event, channel)
    head :ok
  rescue JSON::ParserError => e
    Rails.logger.error "[Wazapi] JSON parse error: #{e.message}"
    head :bad_request
  end

  private

  def find_channel
    instance_id = params[:instance_id]
    return nil if instance_id.blank?

    Channel::Wazapi.find_by(instance_id: instance_id)
  end

  def handle_event(event, channel)
    case event['event']
    when 'message'
      handle_message(event, channel)
    when 'message_ack'
      handle_ack(event, channel)
    when 'connection'
      Rails.logger.info "[Wazapi] Connection event: #{event['state']}"
    else
      Rails.logger.warn "[Wazapi] Unhandled event: #{event['event']}"
    end
  end

  def handle_message(event, channel)
    phone = event.dig('data', 'from') || event.dig('data', 'phone')
    message_body = event.dig('data', 'body') || event.dig('data', 'message')
    message_id = event.dig('data', 'id') || event.dig('id')
    is_from_me = event.dig('data', 'fromMe') || false
    timestamp = event.dig('data', 'timestamp') || Time.current.to_i
    media_url = event.dig('data', 'mediaUrl')
    media_type = event.dig('data', 'mediaType')

    # Ignora mensagens enviadas por nós mesmos
    return if is_from_me

    inbox = channel.inbox
    return unless inbox

    contact = find_or_create_contact(phone, channel)
    conversation = find_or_create_conversation(contact, inbox)

    message = create_message(conversation, message_body, message_id, timestamp)
    attach_media(message, media_url, media_type) if media_url.present?
  end

  def find_or_create_contact(phone, channel)
    Contact.find_or_create_by!(
      account_id: channel.account_id,
      phone_number: phone
    ) do |c|
      c.name = phone
    end
  end

  def find_or_create_conversation(contact, inbox)
    Conversation.find_or_create_by!(
      account_id: inbox.account_id,
      inbox_id: inbox.id,
      contact_id: contact.id,
      status: :open
    )
  end

  def create_message(conversation, content, external_id, timestamp)
    conversation.messages.create!(
      content: content,
      message_type: :incoming,
      external_source_id: external_id,
      created_at: Time.at(timestamp)
    )
  end

  def attach_media(message, media_url, media_type)
    # Download do Wazapi e anexar como attachment
    require 'open-uri'
    file = URI.parse(media_url).open
    message.attachments.attach(
      io: file,
      filename: "wazapi_#{message.id}_#{media_type}",
      content_type: mime_for(media_type)
    )
  rescue StandardError => e
    Rails.logger.error "[Wazapi] Failed to attach media: #{e.message}"
  end

  def mime_for(media_type)
    case media_type
    when 'image' then 'image/jpeg'
    when 'video' then 'video/mp4'
    when 'audio' then 'audio/ogg'
    when 'document' then 'application/octet-stream'
    when 'sticker' then 'image/webp'
    else 'application/octet-stream'
    end
  end

  def handle_ack(event, channel)
    ack = event.dig('data', 'ack')
    message_id = event.dig('data', 'id')
    return if ack.blank? || message_id.blank?

    message = Message.find_by(external_source_id: message_id)
    return unless message

    # ack codes do WhatsApp: 1=send, 2=delivered, 3=read
    status = case ack
             when 1, 2 then :delivered
             when 3 then :read
             else :sent
             end
    message.update(status: status)
  end
end
