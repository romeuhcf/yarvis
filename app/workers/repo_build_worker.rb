class RepoBuildWorker
  include Sidekiq::Worker
  def perform(repo_id, revision)
    repo = Repository.find(repo_id)
    repo.repository_for_revision(revision)
    revision_path = repo.revision_repository_checkout_path(revision)
    runner = DockerRunner.new(revision_path)
    runner.start

    DockerRunnerMonitorWorker.perform_in(1, repo_id, revision, runner.id)
  end
  include NonOverlappingWorker
end
