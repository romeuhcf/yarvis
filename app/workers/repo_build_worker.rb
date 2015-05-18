class RepoBuildWorker
  include Sidekiq::Worker

  def perform(repo_id, revision)

  end
end
