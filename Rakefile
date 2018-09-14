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
  puts 'bundle exec stuff'
  sh 'bundle install'
  sh 'bundle update'
end

# desc 'Foodcritic of new code'
# task :foodcritic do
#   puts 'Running Foodcritic linting tests...'
#   sh 'foodcritic . -f any'
# end

desc 'Build VM with cookbook'
task :create do
  puts 'run kitchen task create'
  sh 'ANSIBLE_Vs=vvv KITCHEN_LOCAL_YAML=.kitchen.digitalocean.yml bundle exec '\
          "kitchen create #{ENV['suite']}-#{ENV['platform']} --log-level DEBUG"
end

desc 'Converge VM with cookbook'
task :converge do
  puts 'run kitchen tasks'
  sh 'ANSIBLE_Vs=vvv KITCHEN_LOCAL_YAML=.kitchen.digitalocean.yml bundle exec '\
          "kitchen converge #{ENV['suite']}-#{ENV['platform']}"
end

desc 'Build VM with cookbook'
task :verify do
  puts 'run kitchen tasks'
  sh 'KITCHEN_LOCAL_YAML=.kitchen.digitalocean.yml bundle exec '\
          "kitchen verify #{ENV['suite']}-#{ENV['platform']}"
end

desc 'Destroy VM'
task :destroy do
  puts 'run kitchen tasks'
  sh 'KITCHEN_LOCAL_YAML=.kitchen.digitalocean.yml bundle exec '\
          "kitchen destroy #{ENV['suite']}-#{ENV['platform']}"
end
