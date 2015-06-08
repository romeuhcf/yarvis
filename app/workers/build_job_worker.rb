class BuildJobWorker
  include Sidekiq::Worker

  def perform(build_job_id)
    build_job = BuildJob.find(build_job_id)
    begin
      spawn_docker(build_job)
      follow_docker(build_job)
    rescue => e
      build_job.status = 'error'
      build_job.error = [e.class, e.message, e.backtrace.first].join(', ')
    ensure
      build_job.save!
    end
  end

  def spawn_docker(build_job)
    build_job.status = 'running'
    build_job_path = build_job.provision_path!

    container_name = [build_job.class.name, build_job.id].join('@')

    runner = DockerRunner.new(build_job_path, build_job.build_spec, container_name)
    build_job.container_id = runner.id

    runner.start
    # TODO schedule repo clean of build_job_path
  end

  def follow_docker(build_job)
    DockerRunnerMonitorWorker.perform_in(5, build_job.id)
  end

  include NonOverlappingWorker
end
