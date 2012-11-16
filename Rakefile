SCRIPT_FILE = "lib/zoom.js"

task :build do
  `cat src/js/jquery.js > #{SCRIPT_FILE}`
  `cat src/js/libraries/*.js >> #{SCRIPT_FILE}`
  `node_modules/.bin/coffee -p -c src >> #{SCRIPT_FILE}`
  puts 'compile done'
end

task watch: [:build] do
  require 'listen'

  Listen.to('src') do |modified, added, removed|
    Rake::Task["build"].execute
  end

end

task :test do
  system "bundle exec ruby test/test.rb"
end