require 'fileutils'
class Repository < ActiveRecord::Base

  scope :active_check, -> { where(active_check: true) }
  scope :enabled,      -> { where(enabled: true) }

  def last_remote_revision(branch = 'master')
    out, err, status = run_command("git ls-remote #{self.url} HEAD")

    if status.success?
      out.first.split(/\s+/).first
    else
      fail err.join("\n")
    end
  end

  def run_command(cmd)
    trace('subprocess.git.ls-remote') do
      require 'open3'
      puts "Running command #{cmd}"
      stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
      stdin.close_write
      out = stdout.readlines
      err = stderr.readlines
      exit_status = wait_thr.value
      return [out, err, exit_status]
    end
  end

  def trace(tag)
    init = Time.now
    yield
    taken = Time.now - init
    logger.info(p("Trace: %s. Taken: %0.3f s" % [tag, taken]))
  end

  def update_central_repository
    unless central_repository_checkout?
      central_repository_checkout!
    end

    central_repository_update!
  end

  require "rsync"
  def repository_for_revision(revision)
    update_central_repository
    rsync_args = %w{ -a --delete }
    Rsync.run(central_repository_checkout_path + '/', revision_repository_checkout_path(revision) + '/', rsync_args)
    repo_at(revision).checkout(revision, strategy: [:force])
  end

  private

  def central_repository_checkout!
    valid_url = url.gsub(
      'bitbucket.org:',
      'altssh.bitbucket.org:443/'
    ).gsub(
      'git@',
      'ssh://git@'
    ) # XXX TODO implement real url parse and substitution when required

    puts "Cloning repo: #{valid_url} at #{central_repository_checkout_path}"
    Rugged::Repository.clone_at valid_url, central_repository_checkout_path , :credentials => credentials
  end

  def credentials
    Rugged::Credentials::SshKey.new({
      username: 'git',
      publickey: File.expand_path("~/.ssh/id_rsa.pub"),
      privatekey: File.expand_path("~/.ssh/id_rsa")
    }) # TODO implement real url parse and credentials options
  end


  def central_repository_checkout_path
    revision_repository_checkout_path('HEAD')
  end

  def central_repository_checkout?
    crcp = central_repository_checkout_path
    File.exist?(crcp) && File.directory?(crcp) && repo && !repo.empty?
  end

  def cache_dir
    Settings.get('cached_dir', default: '/tmp/yarvis', ttl: 1.hour, desc: 'Where to put cacheable files')
  end

  def repo
    Rugged::Repository.new(central_repository_checkout_path)
  end

  def central_repository_update!
    #    git fetch:
    remote = repo.remotes['origin']
    remote.fetch(credentials: credentials)

    distant_commit = repo.branches["origin/master"].target
    repo.references.update(repo.head, distant_commit.oid)
  end

  def revision_repository_checkout_path(revision)
    File.join(cache_dir, 'repos', "repo:#{self.id}", revision)
  end

  def repo_at(revision)
    Rugged::Repository.new(revision_repository_checkout_path(revision))
  end
end
