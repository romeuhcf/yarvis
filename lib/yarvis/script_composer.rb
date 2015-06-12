module Yarvis
  class ScriptComposer
    attr_reader :command_sets
    def initialize(command_sets)
      @command_sets = command_sets
    end

    def to_script
      [
        command_sets.map(&:to_script),
        build_step_caller_script,
        build_step_pipeline_script,
      ].flatten.join("\n")
    end

    def build_step_caller_script
      step_timeout = 15.minutes
      [
        'FAILED_STEP_RESULT=0',
        "TIMEOUT=#{step_timeout}",
        "function step_caller(){",
        '  STEP_LABEL="$1"',
        '  echo "@@@ START:$STEP_LABEL MOMENT:$(date +%s) @@@"',
        '  if [ "$FAILED_STEP_RESULT" -ne 0 ]; then',
        '    echo "@@@ FINISH:$STEP_LABEL MOMENT:$(date +%s) STATUS:skipped @@@"',
        '  else',
        '    echo',
        '    step_$STEP_NAME',
        '    STEP_RESULT=$?',
        '    echo',
        '    if [ $STEP_RESULT -eq 0 ]; then',
        '      echo "@@@ FINISH:$STEP_LABEL MOMENT:$(date +%s) STATUS:success @@@"',
        '    else',
        '      echo "@@@ FINISH:$STEP_LABEL MOMENT:$(date +%s) STATUS:$STEP_RESULT @@@"',
        '      FAILED_STEP_RESULT=$STEP_RESULT',
        '    fi',
        '  fi',
        '}',
      ]
    end


    def build_step_pipeline_script
      step_labels = @command_sets.map{|s| Shellwords.escape(s.label)}.join(' ')
      [
        'echo "@@@ FINISH:world MOMENT:$(date +%s) STATUS:success @@@"',
        "for STEP_NAME in #{step_labels}",
        'do',
        '  step_caller "$STEP_NAME"',
        'done',
        'exit $FAILED_STEP_RESULT',
      ]
    end
  end
end
