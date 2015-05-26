class Changeset < ActiveRecord::Base
  include CloneTree
  belongs_to :repository
  has_many :build_jobs, dependent: :destroy

  def provision_path!
    clone_tree(repository.provision_path!, provision_path)
    SourceCode.new(provision_path).checkout(revision)
    return provision_path
  end

  def provision_path
    @_provision_path ||= [repository.base_path, [self.class.name, self.id, revision].join('@')].join('/')
  end
end
