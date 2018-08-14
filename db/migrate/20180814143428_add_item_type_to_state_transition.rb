class AddItemTypeToStateTransition < ActiveRecord::Migration[5.2]
  def change
    add_column :state_transitions, :item_type, :string
    add_column :state_transitions, :item_id, :integer
  end
end
