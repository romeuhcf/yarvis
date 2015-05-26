class BuildJobWorker
  include Sidekiq::Worker
  def perform(build_job_id)
    build_job = BuildJob.find(build_job_id)
    build_job_path = build_job.provision_path!

    container_name = [build_job.class.name, build_job.id].join('@')

    runner = DockerRunner.new(build_job_path, build_job.build_spec, container_name)
    build_job.container_id = runner.id
    build_job.save!

    runner.start
    DockerRunnerMonitorWorker.perform_in(5, build_job_id)
    # TODO schedule repo clean of build_job_path
  end
  include NonOverlappingWorker
end
