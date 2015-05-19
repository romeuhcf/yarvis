class ChangesetWorker
  include Sidekiq::Worker
  def perform(changeset_id)
    changeset = Changeset.find(changeset_id)
    revision_path = changeset.provision_path!

    BuildSpecMatrix.new(revision_path).specs.each do |build_spec|
      build_job = BuildJob.from_spec!(build_spec)
      BuildJobWorker.perform_async(build_job.id)
    end
  end
  include NonOverlappingWorker
end


