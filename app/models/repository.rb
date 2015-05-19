class Repository < ActiveRecord::Base
include CommandRunner

  has_many :changesets, dependent: :destroy

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

  def update_source_code!
    code = SourceCode.new(provision_path)
    if not code.nice?
      code.checkout!
    end

    code.pull(credentials)
  end

  def provision_path!
    path = provision_path
    update_source_code!
    return path
  end

  def provision_path
    File.join(base_path, 'HEAD')
  end

  def base_path
    File.join(cache_dir, 'repos', "repo@#{self.id}")
  end

  private
  def checkout!
    valid_url = url.gsub(
      'bitbucket.org:',
      'altssh.bitbucket.org:443/'
    ).gsub(
      'git@',
      'ssh://git@'
    ) # XXX TODO implement real url parse and substitution when required

    SourceCode.clone_at valid_url, provision_path, :credentials => credentials
  end

  def credentials
    Rugged::Credentials::SshKey.new({
      username: 'git',
      publickey: File.expand_path("~/.ssh/id_rsa.pub"),
      privatekey: File.expand_path("~/.ssh/id_rsa")
    }) # TODO implement real url parse and credentials options
  end

  def cache_dir
    Settings.get('cached_dir', default: '/tmp/yarvis', ttl: 1.hour, desc: 'Where to put cacheable files')
  end
end
