class AddStretchMarkToUser < ActiveRecord::Migration
  def change
    add_column :users, :stretch_mark, :string
  end
end
