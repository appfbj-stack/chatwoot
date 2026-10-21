class AddCachedLabelsList < ActiveRecord::Migration[7.0]
  def change
    add_column :conversations, :cached_label_list, :string
    Conversation.reset_column_information
    # acts-as-taggable-on >= 12.0 renamed the module to `Caching` (was `Cache`)
    ActsAsTaggableOn::Taggable::Caching.included(Conversation)
  end
end
