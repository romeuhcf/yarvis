class DockerRunnerMonitorWorker
  include Sidekiq::Worker

  def perform(build_job_id)
    build_job = BuildJob.find(build_job_id)
    runner = DockerRunner.from_container_id(build_job.container_id)

    begin
      if runner.running?
        self.class.perform_in(5, build_job_id)
      else
        build_job.exit_status = runner.exit_status
        build_job.finished_at = runner.finished_at
        build_job.status = build_job.exit_status == 0  ? 'success' : 'error'
      end
    ensure
      build_job.log = runner.logs
      build_job.save!
    end

  end
  include NonOverlappingWorker
end
