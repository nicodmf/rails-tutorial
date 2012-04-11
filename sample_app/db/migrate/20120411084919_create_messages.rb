class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :user_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :messages, :user_id
    add_index :messages, :receiver_id
  end
end
