require 'rails_helper'
require 'fileutils'

describe CloneTree do
  subject {
    Class.new do
      include CloneTree
    end.new
  }

  let(:tmp_dir_0) do
    path = File.join('/tmp', SecureRandom.hex(4))
    FileUtils.mkdir_p(File.join(path, 'dir/with'))
    FileUtils.touch(File.join(path, 'file'))
    FileUtils.touch(File.join(path, 'dir/with/dir'))
    FileUtils.touch(File.join(path, '.hidden'))
    next path
  end


  let(:tmp_dir_a) { File.join('/tmp', SecureRandom.hex(4)) }
  let(:tmp_dir_b) { File.join('/tmp', SecureRandom.hex(4)) }

  after {
    FileUtils.rm_f(tmp_dir_a)
    FileUtils.rm_f(tmp_dir_b)
    FileUtils.rm_f(tmp_dir_0)
  }

  describe '#clone_tree' do
    it 'compies everything including hidden files' do
      subject.clone_tree(tmp_dir_0, tmp_dir_a)

      expect(File.exist?(File.join(tmp_dir_a, 'file') )).to be true
      expect(File.exist?(File.join(tmp_dir_a, 'dir/with/dir') )).to be true
      expect(File.exist?(File.join(tmp_dir_a, '.hidden') )).to be true
    end

    it 'removes extra files at destination' do
      subject.clone_tree(tmp_dir_0, tmp_dir_a)
      subject.clone_tree(tmp_dir_a, tmp_dir_b)
      FileUtils.touch(File.join(tmp_dir_b, 'extra_file'))
      expect(File.exist?(File.join(tmp_dir_b, 'extra_file') )).to be true
      subject.clone_tree(tmp_dir_a, tmp_dir_b)
      expect(File.exist?(File.join(tmp_dir_b, 'extra_file') )).to be false
    end
  end
end
