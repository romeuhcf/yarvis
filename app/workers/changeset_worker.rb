require 'yarvis/config'

class ChangesetWorker
  include Sidekiq::Worker
  def perform(changeset_id)
    changeset = Changeset.find(changeset_id)
    begin
      spawn_build_jobs(changeset)
      follow_build_jobs(changeset)
    rescue => e
      changeset.status = 'error'
      changeset.error = [e.class, e.message, e.backtrace.first].join(', ')
    ensure
      changeset.save!
    end
  end

  def spawn_build_jobs(changeset)
    changeset.status = 'running'
    revision_path = changeset.provision_path!

    matrix = Yarvis::Config.from_yaml(File.join(revision_path, ".yarvis.yml")).matrix

    matrix_size_limit = Settings.get('matrix.sizelimit', default: 4)
    specs = matrix.specs[0,matrix_size_limit]

    specs.each do |build_spec|
      build_job = BuildJob.from_spec!(build_spec, changeset)
      BuildJobWorker.perform_async(build_job.id)
    end
  end

  def follow_build_jobs(changeset)
    ChangesetMonitorWorker.perform_in(5, changeset.id)
  end

  include NonOverlappingWorker
end
