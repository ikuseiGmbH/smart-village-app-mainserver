class AddExternalIdToEventRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :event_records, :external_id, :integer
  end
end
