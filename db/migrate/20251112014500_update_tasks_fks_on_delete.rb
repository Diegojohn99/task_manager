class UpdateTasksFksOnDelete < ActiveRecord::Migration[8.1]
  def up
    # tasks.user_id -> users.id ON DELETE CASCADE
    remove_foreign_key :tasks, :users
    add_foreign_key :tasks, :users, on_delete: :cascade

    # tasks.category_id -> categories.id ON DELETE SET NULL
    remove_foreign_key :tasks, :categories
    add_foreign_key :tasks, :categories, on_delete: :nullify
  end

  def down
    remove_foreign_key :tasks, :users
    add_foreign_key :tasks, :users

    remove_foreign_key :tasks, :categories
    add_foreign_key :tasks, :categories
  end
end
