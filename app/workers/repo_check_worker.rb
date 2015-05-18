class RepoCheckWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(repo_id)
    repo = Repository.find(repo_id)
    last_remote_revision = repo.last_remote_revision
    if last_remote_revision != repo.last_handled_revision
      repo.last_handled_revision = last_remote_revision
      repo.save!
      RepoBuildWorker.perform_in(5, repo.id, last_remote_revision)
    end
    repo.touch(:checked_at)
  end
  include NonOverlappingWorker
end
