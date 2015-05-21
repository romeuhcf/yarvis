module Yarvis
  class BuildSpec
    def initialize(config_hash, dimensions_hash)
      @config = config_hash
      @dimensions_hash = dimensions_hash
    end

    def slug
      @dimensions_hash.values.map(&:slug).join(" | ")
    end

    def docker
      @dimensions_hash[:docker].docker
    end

    def runtime
      @dimensions_hash[:runtime].runtime
    end

    def env_script
      @dimensions_hash[:env].to_script
    end

    def working_directory
      '/code'
    end

    def build_script
      script_lines = []
      build_steps.each do |step|
        script_lines << step_start_line(step)
        script_lines << step
        script_lines << step_finish_line(step)
      end
      script_lines.join(" && ")
    end

    def build_steps
      [
        "bundle install --without development --jobs=3 --retry=3" , # --deployment
        "bundle exec rspec spec",
      ] # TODO get from yaml
    end

    def step_start_line(step)
      "echo '@@@ START: #{step} @@@'"
    end

    def step_finish_line(step)
      "echo '@@@ FINISH: #{step} @@@'"
    end
  end
end
