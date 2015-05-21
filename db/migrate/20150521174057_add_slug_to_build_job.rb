class AddSlugToBuildJob < ActiveRecord::Migration
  def change
    add_column :build_jobs, :slug, :string
  end
end
