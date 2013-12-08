require 'rake/testtask'

def compile_coffee
  `node_modules/.bin/coffee -o lib -c src/js`
end

task :build do
  compile_coffee
  puts 'compile done'
end

task watch: [:build] do
  require 'listen'

  Listen.to('src') do |modified, added, removed|
    Rake::Task["build"].execute
  end.start

  sleep 10 while true
end

Rake::TestTask.new('test') do |t|
  t.libs << "test"
  t.test_files = FileList['test/tests/**/*.rb']
end

task :dist do
  system('rm build.zip')
  system('zip -r build.zip . -x ./src/**\* ./.git/**\* ./test/**\* ./node_modules/**\*')
end