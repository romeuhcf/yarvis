class RepoCheckSpawnClock
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options :retry => false, :backtrace => true

  recurrence { minutely.second_of_minute([0,15,30,45]) }

  def perform
    Repository.enabled.active_check.find_each do |repo|
      RepoCheckWorker.perform_async(repo.id)
    end
  end

end

