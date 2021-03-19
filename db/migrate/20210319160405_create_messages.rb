class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :chat, foreign_key: true
      t.integer :number
      t.text :body

      t.index [:chat_id, :number], unique: true

      t.timestamps
    end
  end
end
