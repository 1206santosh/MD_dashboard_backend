class CreateUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :uploads do |t|
      t.string :item_type
      t.integer :item_id
      t.integer :user_id

      t.timestamps
    end
  end
end
