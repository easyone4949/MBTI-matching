class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :matnum
      t.references :user_id
      
      t.timestamps null: false
    end
  end
end
