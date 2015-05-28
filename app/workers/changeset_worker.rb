require 'yarvis/config'

class ChangesetWorker
  include Sidekiq::Worker
  def perform(changeset_id)
    changeset = Changeset.find(changeset_id)
    revision_path = changeset.provision_path!

    matrix = Yarvis::Config.from_yaml(File.join(revision_path, ".yarvis.yml")).matrix

    matrix_size_limit = Settings.get('matrix.sizelimit', default: 1)
    specs = matrix.specs[0,matrix_size_limit]

    specs.each do |build_spec|
      build_job = BuildJob.from_spec!(build_spec, changeset)
      BuildJobWorker.perform_async(build_job.id)
    end

  end
  include NonOverlappingWorker
end
