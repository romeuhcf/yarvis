class AddLastHandledRevisionToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :last_handled_revision, :string
  end
end
