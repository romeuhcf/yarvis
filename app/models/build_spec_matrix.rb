class BuildSpecMatrix
  def initialize(repo_path)
    @path = repo_path
  end

  def specs
    [BuildSpec.new] # TODO
  end
end
