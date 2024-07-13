class CreateChapters < ActiveRecord::Migration[7.1]
  def change
    create_table :chapters do |t|
      t.integer :course_id, null: false
      t.string :name, null: false
      t.integer :position, null: false, default: 0
      t.timestamps

      t.index :course_id
    end
  end
end
