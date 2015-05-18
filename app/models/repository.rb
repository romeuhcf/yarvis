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

  def checkout(revision = 'HEAD', depth = 1)
    #  git clone --no-checkout --depth 1 git@github.com:foo/bar.git && cd bar && git show HEAD:path/to/file.txt
  end


  def update_central_repository
    unless central_repository_checkout?
      central_repository_checkout!
    end

    central_repository_update!
  end
  private

  def central_repository_checkout!
    valid_url = url.gsub('bitbucket.org:', 'altssh.bitbucket.org:443/').gsub('git@', 'ssh://git@') # XXX TODO
    puts "Cloning repo: #{valid_url} at #{central_repository_checkout_path}"
    Rugged::Repository.clone_at valid_url, central_repository_checkout_path , :credentials => credentials
  end

  def credentials
    Rugged::Credentials::SshKey.new(username: 'git', publickey: File.expand_path("~/.ssh/id_rsa.pub"), privatekey: File.expand_path("~/.ssh/id_rsa"))
  end


  def central_repository_checkout_path
    File.join(cache_dir, 'central_checkout', "repo:#{self.id}")
  end

  def central_repository_checkout?
    crcp = central_repository_checkout_path
    File.exist?(crcp) && File.directory?(crcp) && repo && !repo.empty?
  end

  def cache_dir
    "/tmp/yarvis" # XXX TODO
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
end
