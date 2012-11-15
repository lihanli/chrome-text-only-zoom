SCRIPT_FILE = "lib/zoom.js"

task :build do
  `cat src/js/jquery.js | uglifyjs > #{SCRIPT_FILE}`
  `cat src/js/gritter.js | uglifyjs >> #{SCRIPT_FILE}`
  `cat src/js/mousetrap.js | uglifyjs >> #{SCRIPT_FILE}`
  `coffee -p -c src | uglifyjs >> #{SCRIPT_FILE}`
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