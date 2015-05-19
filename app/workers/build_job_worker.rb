class RepoBuildWorker
  include Sidekiq::Worker
  def perform(build_job_id)
    build_job = BuildJob.find(build_job_id)
    build_job_path = build_job.provision_path!

    runner = DockerRunner.new(build_job_path, build_job.build_spec)
    runner.start
    build_job.container_id = runner.id
    build_job.save!

    DockerRunnerMonitorWorker.perform_in(1, build_job_id)
    # TODO schedule repo clean of build_job_path
  end
  include NonOverlappingWorker
end
