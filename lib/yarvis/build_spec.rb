require 'shellwords'
module Yarvis
  class CommandSet
    attr_reader :label, :commands
    def initialize(label, commands)
      @commands = commands
      @label = label
    end
  end

  class BuildSpec
    def initialize(config_hash, dimensions_hash)
      @config = config_hash
      @dimensions_hash = dimensions_hash
    end

    def slug
      @dimensions_hash.values.map(&:slug).join(" | ")
    end

    def docker_image
      docker_dim.image_tag
    end

    def docker_dim
      @dimensions_hash[:docker]
    end

    def runtime
      runtime_dim.runtime
    end

    def runtime_dim
      @dimensions_hash[:runtime]
    end

    def env_script
      @dimensions_hash[:env].to_script
    end

    def working_directory
      '/code' # TODO.. get from settings as default or from yaml
    end

    def build_script

      script_lines = ['set -e']
      build_steps.each do |step|
        script_lines << step_start_line(step.label)

        step.commands.flatten.compact.map do |cmd|
          script_lines << ["echo " + Shellwords.escape(cmd), cmd]
        end
        script_lines << step_finish_line(step.label)
      end
      script_lines.flatten.compact.join("\n")
    end

    def build_steps
      [
        CommandSet.new(:docker_prepare,[
          docker_dim.commands
        ]),
        CommandSet.new(:code_prepare, [
          "cp -rfv #{working_directory} $HOME/code",
          "cd $HOME/code",
          "rm -rf $HOME/code/.bundle"
        ]),
        CommandSet.new(:runtime_prepare, [
          #          "export BUNDLE_PATH=$HOME/code/.bundle",
          #          "export BUNDLE_DISABLE_SHARED_GEMS=1",
        ]),

        CommandSet.new(:env_prepare, [
          env_script
        ]),

        CommandSet.new(:runtime, [
          "cd $HOME/code",
          "rvm use #{runtime_dim.version} || ( rvm install #{runtime_dim.version} && rvm use #{runtime_dim.version})",
          "bundle install --without development --jobs=3 --retry=3" , # --deployment
          # TODO get from yaml
        ]),


        CommandSet.new(:script, [
          "bundle exec rspec spec"
          # TODO get from yaml
        ])
      ]
    end

    def step_start_line(step_label)
      "echo '@@@ START: #{step_label} @@@'"
    end

    def step_finish_line(step_label)
      "echo '@@@ FINISH: #{step_label} @@@'"
    end
  end
end
