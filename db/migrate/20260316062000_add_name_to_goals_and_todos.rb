class AddNameToGoalsAndTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :goals, :name, :string
    add_column :todos, :name, :string
  end
end
