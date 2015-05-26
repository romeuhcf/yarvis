class DockerRunnerMonitorWorker
  include Sidekiq::Worker
  def perform(build_job_id)
    build_job = BuildJob.find(build_job_id)
    runner = DockerRunner.from_container_id(build_job.container_id)

    if runner.running?
      self.class.perform_in(5, build_job_id)

    else
      build_job.exit_status = runner.exit_status
      build_job.finished_at = runner.finished_at
    end
  ensure
    build_job.log = runner.logs
    build_job.save!
  end
  include NonOverlappingWorker
end
