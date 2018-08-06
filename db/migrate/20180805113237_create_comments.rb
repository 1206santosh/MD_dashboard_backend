class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.string :comment_type
      t.integer :item_id
      t.string :item_type
      t.string :content

      t.timestamps
    end
  end
end
