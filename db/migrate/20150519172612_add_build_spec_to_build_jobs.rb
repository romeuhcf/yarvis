class AddBuildSpecToBuildJobs < ActiveRecord::Migration
  def change
    add_column :build_jobs, :build_spec, :text
  end
end
