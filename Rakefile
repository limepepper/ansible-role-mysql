#
#
cookbook = ENV['COOKBOOK']

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

# desc 'Foodcritic of new code'
# task :foodcritic do
#   puts 'Running Foodcritic linting tests...'
#   sh 'foodcritic . -f any'
# end

desc 'Build VM with cookbook'
task :build do
  puts "Attempting to converge the Kitchen VM with #{cookbook} cookbook"
  sh 'kitchen converge'
end

desc 'Verify the cookbook with Inspec'
task :verify do
  puts 'Running Inspec tests'
  sh 'kitchen verify'
end

desc 'Reset VM'
task :destroy do
  sh 'echo TODO'
end
