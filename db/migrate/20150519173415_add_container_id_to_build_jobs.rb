class AddContainerIdToBuildJobs < ActiveRecord::Migration
  def change
    add_column :build_jobs, :container_id, :string
  end
end
