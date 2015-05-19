class BuildJob < ActiveRecord::Base
  include CloneTree
  belongs_to :changeset
  serialize :log

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
    'default' # TODO generate slug by matrix spec
  end
end
