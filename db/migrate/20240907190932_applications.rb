class Applications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :token, null: false
      t.string :name, null: false, index: true
      t.integer :chat_count, default: 0

      t.timestamps
    end
    add_index :applications, :token, unique: true
  end
end
