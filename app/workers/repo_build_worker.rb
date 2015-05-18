class RepoBuildWorker
  include Sidekiq::Worker

  def perform(repo_id, revision)
    repo = Repository.find(repo_id)
    repo.repository_for_revision(revision)

  end
end
