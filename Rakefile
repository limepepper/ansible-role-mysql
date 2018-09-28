#
#
# cookbook = ENV['COOKBOOK']

task default: [:test]

task lint: %i[yamllint rubocop]

desc 'Yamllint'
task :yamllint do
  puts 'Execution of Yaml linting tests'
  sh 'yamllint .'
end

desc 'Rubocop of new code'
task :rubocop do
  puts 'Execution of Rubocop linting tests'
  sh 'rubocop .'
end

desc 'Run setup'
task :setup do
  # Your code goes here
  puts 'bundle install stuff'
  sh 'bundle install --verbose'
  puts 'bundle update'
  sh 'bundle update --verbose'
end

# desc 'Foodcritic of new code'
# task :foodcritic do
#   puts 'Running Foodcritic linting tests...'
#   sh 'foodcritic . -f any'
# end

# echo some change

local_file = (!ENV['local_file'].nil? && !ENV['local_file'].empty?) && ENV['local_file'] || 'digitalocean'
platform = ENV['platform'] || 'centos-7'
suite = ENV['suite'] || 'default'

puts local_file

desc 'Build VM with cookbook'
task :create do
  puts 'run kitchen task create'

  puts "ENV['local_file']  = '#{ENV['local_file']}'"
  puts "local_file  = '#{local_file}'"

  puts 'ANSIBLE_Vs=vvv '\
          "KITCHEN_LOCAL_YAML=.kitchen.#{local_file}.yml bundle exec "\
          "kitchen create #{suite}-#{platform} --log-level DEBUG"

  sh 'ANSIBLE_Vs=vvv '\
          "KITCHEN_LOCAL_YAML=.kitchen.#{local_file}.yml bundle exec "\
          "kitchen create #{suite}-#{platform} --log-level DEBUG"
end

desc 'Converge VM with cookbook'
task :converge do
  puts 'run kitchen tasks'

  sh 'ANSIBLE_Vs=vvv '\
          "KITCHEN_LOCAL_YAML=.kitchen.#{local_file}.yml bundle exec "\
          "kitchen converge #{suite}-#{platform}"
end

desc 'Build VM with cookbook'
task :verify do
  puts 'run kitchen tasks'

  sh "KITCHEN_LOCAL_YAML=.kitchen.#{local_file}.yml bundle exec "\
          "kitchen verify #{suite}-#{platform}"
end

desc 'Destroy VM'
task :destroy do
  puts 'run kitchen tasks'

  sh "KITCHEN_LOCAL_YAML=.kitchen.#{local_file}.yml bundle exec "\
          "kitchen destroy #{suite}-#{platform}"
end
