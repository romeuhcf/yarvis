Dir[File.join(File.dirname(__FILE__), 'dimension/*.rb')].each do |dim|
  require_relative dim
end
