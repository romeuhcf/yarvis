class AddActiveCheckFlagsToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :enabled, :boolean
    add_column :repositories, :active_check, :boolean
  end
end
