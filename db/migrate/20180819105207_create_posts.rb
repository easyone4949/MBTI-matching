class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string  :name
      t.integer :age
      t.string  :address
      t.string  :hobby
      t.string  :introduce
      t.integer :user_id
      t.string  :kakao_id
      
      t.timestamps null: false
    end
  end
end
