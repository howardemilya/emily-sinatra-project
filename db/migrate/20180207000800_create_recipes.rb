class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :prep_time
      t.string :cook_time
      t.string :instructions
      t.integer :user_id
    end
  end
end
