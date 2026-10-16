# Kairos CRM — Migration: create wazapi channel
# Path no clone: db/migrate/YYYYMMDDHHMMSS_create_channel_wazapi.rb
class CreateChannelWazapi < ActiveRecord::Migration[7.1]
  def change
    create_table :channel_wazapi do |t|
      t.references :account, null: false, foreign_key: true
      t.string  :phone_number, null: false
      t.string  :instance_id, null: false
      t.string  :api_token, null: false
      t.string  :webhook_secret
      t.string  :provider_name, default: 'wazapi'
      t.boolean :enabled, default: true
      t.jsonb   :provider_config, default: {}
      t.timestamps
    end

    add_index :channel_wazapi, :instance_id, unique: true
    add_index :channel_wazapi, :phone_number
  end
end
