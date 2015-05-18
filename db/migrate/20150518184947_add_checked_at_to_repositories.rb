class AddCheckedAtToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :checked_at, :datetime
  end
end
