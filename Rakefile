require 'rubygems'
require 'rake'

PORT = '4000'

desc "Launch preview"
task :preview do
  system "rackup -p #{PORT}"
end # task : preview

desc "Launch preview with shotgun"
task :server do
  system "shotgun --server=thin --port=#{PORT} config.ru"
end # task :server