require 'rails_helper'
require 'yarvis/command_set'
describe Yarvis::CommandSet do
  subject {described_class.new('test_set1', [
    "pwd",
    "ls -lthr",
    "wakka",
    'echo " oi mae "'
  ] )}

  let(:expected_step_script) { s =<<-EOF
function step_test_set1(){
  timeout "$TIMEOUT" bash << EOT
    echo '#' pwd &&
    pwd &&
    echo '#' ls\\ -lthr &&
    ls -lthr &&
    echo '#' wakka &&
    wakka &&
    echo '#' echo\\ \\"\\ oi\\ mae\\ \\" &&
    echo " oi mae "
EOT
}
                                  EOF
                                  s.strip
  }


  it { expect(subject.label).to eq 'test_set1' }
  it { expect(subject.to_script).to eq expected_step_script }
end
