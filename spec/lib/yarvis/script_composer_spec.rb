require 'rails_helper'
require 'yarvis/command_set'
require 'yarvis/script_composer'


describe Yarvis::ScriptComposer do
  let(:set1)  {Yarvis::CommandSet.new('test_set1', ['echo a', 'dddd', 'echo b'])}
  let(:set2)  {Yarvis::CommandSet.new('test_set2', ['echo c'])}

  let(:expectation) {File.read(__FILE__).split(/__END__\n/).last.strip }
  subject     {described_class.new([set1, set2]) }

  it {expect(subject.to_script.strip).to eq expectation}
  it {expect(subject.to_script.strip).to include 'step_caller'}

  it "is tested on real bash call" do
    file = Tempfile.new('foo')
    file.write(subject.to_script)
    file.close
    #puts file.path;sleep 100
    ret = %x{/bin/bash '#{file.path}' 2>&1}
    expect( ret.gsub( /14\d+/, '14????????')).to eq("@@@ START:test_set1 MOMENT:14???????? @@@\n\n# echo a\na\n# dddd\nbash: linha 4: dddd: comando não encontrado\n\n@@@ FINISH:test_set1 MOMENT:14???????? STATUS:127 @@@\n@@@ START:test_set2 MOMENT:14???????? @@@\n@@@ FINISH:test_set2 MOMENT:14???????? STATUS:skipped @@@\n")
  end
end


__END__
function step_test_set1(){
  timeout "$TIMEOUT" bash << EOT
    echo '#' echo\ a &&
    echo a &&
    echo '#' dddd &&
    dddd &&
    echo '#' echo\ b &&
    echo b
EOT
}
function step_test_set2(){
  timeout "$TIMEOUT" bash << EOT
    echo '#' echo\ c &&
    echo c
EOT
}
FAILED_STEP_RESULT=0
TIMEOUT=900
function step_caller(){
  STEP_LABEL="$1"
  echo "@@@ START:$STEP_LABEL MOMENT:$(date +%s) @@@"
  if [ "$FAILED_STEP_RESULT" -ne 0 ]; then
    echo "@@@ FINISH:$STEP_LABEL MOMENT:$(date +%s) STATUS:skipped @@@"
  else
    echo
    step_$STEP_NAME
    STEP_RESULT=$?
    echo
    if [ $STEP_RESULT -eq 0 ]; then
      echo "@@@ FINISH:$STEP_LABEL MOMENT:$(date +%s) STATUS:success @@@"
    else
      echo "@@@ FINISH:$STEP_LABEL MOMENT:$(date +%s) STATUS:$STEP_RESULT @@@"
      FAILED_STEP_RESULT=$STEP_RESULT
    fi
  fi
}
for STEP_NAME in test_set1 test_set2
do
  step_caller "$STEP_NAME"
done
exit $FAILED_STEP_RESULT
