module CommandRunner
  def run_command(cmd)
    require 'open3'
    puts "Running command #{cmd}"
    stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
    stdin.close_write
    out = stdout.readlines
    err = stderr.readlines
    exit_status = wait_thr.value
    return [out, err, exit_status]
  end
end
