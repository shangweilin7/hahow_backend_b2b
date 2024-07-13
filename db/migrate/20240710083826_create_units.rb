class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.integer :chapter_id, null: false
      t.string :name, null: false
      t.string :description, null: true
      t.text :content, null: false
      t.integer :position, null: false, default: 0
      t.timestamps

      t.index :chapter_id
    end
  end
end
