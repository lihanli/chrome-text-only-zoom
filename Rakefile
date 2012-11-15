SCRIPT_FILE = "lib/zoom.js"

task :build do
  `cat src/js/*.js | uglifyjs > #{SCRIPT_FILE}`
  `coffee -p -c src | uglifyjs >> #{SCRIPT_FILE}`
  #`stylus -c < src/css/spinner_helper.styl > #{CSS_FILE}`
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