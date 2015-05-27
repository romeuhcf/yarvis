require 'yarvis/docker_builder'
namespace :docker do
  namespace :images do
    desc "Create all images from config/dockerfiles"
    task :create do
      pattern = File.join(File.dirname(__FILE__), "../../config/dockerfiles/*.dockerfile")
      Dir[pattern].each do |dockerfile|
        basename = File.basename(dockerfile, '.dockerfile')
        puts "Creating #{basename}"
        Yarvis::DockerBuilder.build(dockerfile, basename)

      end
    end
  end
end
