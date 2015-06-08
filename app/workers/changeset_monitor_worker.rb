class ChangesetMonitorWorker
  include Sidekiq::Worker

  def perform(changeset_id)
    changeset = Changeset.includes(:build_jobs).find(changeset_id)
    begin
      build_jobs = changeset.build_jobs
      if build_jobs.any?(&:running?)
        self.class.perform_in(5, changeset_id)
      elsif build_jobs.any?(&:success?)
        changeset.status = 'success'
      else
        changeset.status = 'error'
        changeset.error = "Failed build jobs found: %d of %d" % [build_jobs.select(&:failed?).count, build_jobs.count]
      end
    ensure
      changeset.save!
    end
  end

  include NonOverlappingWorker
end
