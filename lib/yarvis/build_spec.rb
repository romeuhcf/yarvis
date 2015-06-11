require 'yarvis/command_set'
require 'yarvis/script_composer'

module Yarvis
  class BuildSpec
    def initialize(config, dimensions_hash)
      @config = config
      @dimensions_hash = dimensions_hash || default_dimensions_hash
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
      ScriptComposer.new(command_set_list).to_script
    end

    def command_set_list
        [
          CommandSet.new(:docker_prepare,[
            docker_dim.commands
          ]),
          CommandSet.new(:code_prepare, [
            "cp -rf #{working_directory} $HOME/code",
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
        ] + assemble_script_command_sets
    end

    def assemble_script_command_sets
      @config.script.map do |item|
        script_item_to_command_set('script', item)
      end
    end

    def script_item_to_command_set(label_prefix, item)
      CommandSet.new(
        [label_prefix, script_item_to_label(item)].join('_').to_sym,
        script_item_to_command_list(item)
      )
    end

    def script_item_to_label(item)
      if item.is_a? Hash
        item.keys.first
      else
        item.parameterize
      end
    end

    def script_item_to_command_list(item)
      data = if item.is_a? Hash
               item.values
             else
               [item]
             end

      data.flatten.compact
    end

    def default_dimensions_hash
      # TODO from detected runtime
    end

  end
end
