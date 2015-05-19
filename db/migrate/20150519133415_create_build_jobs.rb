class CreateBuildJobs < ActiveRecord::Migration
  def change
    create_table :build_jobs do |t|
      t.belongs_to :changeset, index: true
      t.integer :exit_status
      t.datetime :started_at
      t.datetime :finished_at
      t.text :log

      t.timestamps
    end
  end
end
