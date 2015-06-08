class AddStatusToBuildJob < ActiveRecord::Migration
  def change
    add_column :build_jobs, :status, :string, default: 'running'
    add_column :build_jobs, :error, :string
  end
end
