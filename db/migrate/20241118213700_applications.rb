class Applications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :token, null: false, index: true
      t.string :name, null: false
      t.integer :chat_count, default: 0

      t.timestamps
    end
  end
end
