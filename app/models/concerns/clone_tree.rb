require 'rsync'
module CloneTree
  def clone_tree(from, to)
    rsync_args = %w{ -a --delete }
    Rsync.run(from + '/', to + '/', rsync_args)
  end
end

