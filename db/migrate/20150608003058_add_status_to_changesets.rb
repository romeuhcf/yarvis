class AddStatusToChangesets < ActiveRecord::Migration
  def change
    add_column :changesets, :status, :string, default: 'running'
    add_column :changesets, :error, :string
  end
end
