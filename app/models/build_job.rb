class BuildJob < ActiveRecord::Base
  include CloneTree
  belongs_to :changeset
  serialize :log
  serialize :build_spec
  validates :conatiner_id, uniqueness: true

  def self.from_spec!(build_spec, changeset)
    self.create!(changeset: changeset, build_spec: build_spec.json)
  end

  def running?
    finished_at.blank?
  end

  def run_time
    (finished_at || Time.now) - started_at
  end

  def provision_path!
    clone_tree(changeset.provision_path!, provision_path)
    provision_path
  end

  def provision_path
    @_provision_path ||= [changeset.provision_path, slug].join('@')
  end

  def slug
    'default' # TODO generate slug by build spec
  end
end
