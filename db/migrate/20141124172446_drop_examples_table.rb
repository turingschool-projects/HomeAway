class DropExamplesTable < ActiveRecord::Migration
  def change
    drop_table :examples
  end
end
