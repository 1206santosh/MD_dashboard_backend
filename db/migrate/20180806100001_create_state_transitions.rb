class CreateStateTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :state_transitions do |t|
      t.string :from
      t.string :to
      t.integer :transition_by
      t.text :comment

      t.timestamps
    end
  end
end
