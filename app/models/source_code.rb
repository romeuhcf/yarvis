class SourceCode
  def initialize(path)
    @path = path
    @repo = Rugged::Repository.new(path)
  end

  def checkout(revision)
    @repo.checkout(revision, strategy: [:force])
  end

  def self.clone_at(url, path, credentials)
    logger.info "Cloning repo: #{url} at #{path}"
    Rugged::Repository.clone_at url, path , credentials
    self.new(path)
  end

  def pull(credentials)
    remote = @repo.remotes['origin']
    remote.fetch(credentials: credentials)

    distant_commit = @repo.branches["origin/master"].target
    @repo.references.update(@repo.head, distant_commit.oid)
  end

  def nice?
    File.exist?(@path) && File.directory?(@path) && @repo && !@repo.empty?
  end
end
