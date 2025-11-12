class UpdateCategoriesUserFkOnDeleteCascade < ActiveRecord::Migration[8.1]
  def up
    remove_foreign_key :categories, :users
    add_foreign_key :categories, :users, on_delete: :cascade
  end

  def down
    remove_foreign_key :categories, :users
    add_foreign_key :categories, :users
  end
end
