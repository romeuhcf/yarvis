require 'docker'
module Yarvis
  module DockerBuilder
    def self.build(dockerfile, tag)
      cmd = "docker build -f #{dockerfile} --rm=true -t #{tag} ."
      system cmd
    end
  end
end
