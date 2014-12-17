class ChangeColumnsInProperties < ActiveRecord::Migration
  def change
    add_column "properties", "occupancy", :integer
    add_reference "properties", "address", index: true
    add_column "properties", "bathroom_private", :boolean, default: true

    add_reference "properties", "user", index: true

    add_reference "properties", "category", index: true

  end
end
