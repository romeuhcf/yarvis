module Yarvis
  class CommandSet
    attr_reader :label, :commands
    def initialize(label, commands)
      @commands = commands
      @label = label
    end

    def to_script
      [
        "function step_#{label}(){" ,
        '  timeout "$TIMEOUT" bash << EOT',
        commands.flatten.compact.map{ |cmd|     ["    echo '#' #{Shellwords.escape(cmd)}" , "    " +  cmd] }.join(" &&\n"),
        'EOT',
        "}"
      ].flatten.join("\n")
    end

  end
end
