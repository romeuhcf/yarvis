class BuildJob < ActiveRecord::Base
  belongs_to :changeset
  serialize :log

  def running?
    finished_at.blank?
  end

  def run_time
    (finished_at || Time.now) - started_at
  end

  def provision_path!
    path = provision_path
    rsync_path(changeset.provision_path!, self.provision_path)
    path
  end

  def provision_path
    [changeset.provision_path, slug].join('@')
  end

  def slug
    'default' # TODO generate slug by matrix spec
  end
end
