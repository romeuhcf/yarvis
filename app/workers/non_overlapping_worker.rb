module NonOverlappingWorker
  def self.included(base)
    base.class_eval do
      alias_method_chain :perform, :protection
    end
  end

  def perform_with_protection(*args)
    key = protection_key(*args)
    if Sidekiq.redis{|r| r.get(key) }
      puts "Skipping #{key} ... already running"
    else
      call_original_perform(*args)
    end
  end

  def call_original_perform(*args)
    key = protection_key(*args)
    begin
      puts "Running protected version of #{key}"
      Sidekiq.redis{|r| r.set(key, 1); r.expire(key, 60)}
      perform_without_protection(*args)
    ensure
      zap_protection(*args)
    end
  end

  def zap_protection(*args)
    Sidekiq.redis{|r| r.del(protection_key(*args)) }
  end

  def protection_key(*args)
    [self.class.name, args].flatten.join('-')
  end
end
