class CreateHostRequests < ActiveRecord::Migration
  def change
    create_table :host_requests do |t|
      t.references :user, index: true
      t.string :message
    end
  end
end
