class CreateChangesets < ActiveRecord::Migration
  def change
    create_table :changesets do |t|
      t.belongs_to :repository, index: true
      t.string :revision
      t.string :commit_message

      t.timestamps
    end
  end
end
