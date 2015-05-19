class Changeset < ActiveRecord::Base
  belongs_to :repository
  has_many :build_jobs, dependent: :destroy
end
