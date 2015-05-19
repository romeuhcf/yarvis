class DockerRunnerMonitorWorker
  include Sidekiq::Worker
  def perform(repo_id, revision, runner_id)
    runner = DockerRunner.from_container_id(runner_id)
    puts runner.pp_logs

    if runner.running?
      self.class.perform_in(5, repo_id, revision, runner.id)
    end
  end
  include NonOverlappingWorker
end
