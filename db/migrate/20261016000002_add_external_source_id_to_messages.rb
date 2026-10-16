# Kairos CRM — Migration: add external_source_id to messages (for Wazapi dedup)
# Path no clone: db/migrate/YYYYMMDDHHMMSS_add_external_source_id_to_messages.rb
class AddExternalSourceIdToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :external_source_id, :string
    add_index :messages, :external_source_id
  end
end
