CONTENT_SCRIPT = "lib/zoom.js"

def compile_coffee(name, append = false)
  `node_modules/.bin/coffee -p -c src/js/#{name}.coffee #{append ? '>>' : '>'} lib/#{name}.js`
end

task :build do
  `cat src/js/jquery.js > #{CONTENT_SCRIPT}`
  `cat src/js/libraries/*.js >> #{CONTENT_SCRIPT}`
  compile_coffee 'zoom', true
  compile_coffee 'background'
  compile_coffee 'util'
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