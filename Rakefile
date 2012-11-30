def compile_coffee(name, append = false)
  `node_modules/.bin/coffee -p -c src/js/#{name}.coffee #{append ? '>>' : '>'} lib/#{name}.js`
end

task :build do
  `cat src/js/libraries/*.js > lib/zoom.js`
  compile_coffee 'zoom', true
  %w(background util popup).each { |f| compile_coffee f }
  puts 'compile done'
end

task watch: [:build] do
  require 'listen'
  Listen.to('src') do |modified, added, removed|
    Rake::Task["build"].execute
  end
end

task :test do
  Dir.glob('test/tests/**/*.rb').each { |t| require "./#{t}" }
end