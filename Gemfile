#
# This file was originally generated by ansible. if you run ansible again
# your changes will be lost
#

source 'https://rubygems.org'

# jenkins is remote, so no local paths
if ENV['JENKINS_HOME']
  gem 'inspec', git: 'https://github.com/limepepper/inspec', branch: 'master'
  gem 'kitchen-digitalocean',
      git: 'https://github.com/limepepper/kitchen-digitalocean',
      branch: 'firewall-add'
  gem 'kitchen-inspec'

elsif ENV['LOCAL_DEV']
  # gem 'inspec', path: '/home/tomhodder/git/inspec'
  gem 'inspec', '>= 2.0'
  gem 'kitchen-digitalocean', path: '/home/tomhodder/git/kitchen-digitalocean'
  gem 'kitchen-docker'
  gem 'kitchen-inspec'
  gem 'kitchen-vagrant'
  gem 'test-kitchen', path: '/home/tomhodder/git/test-kitchen'

else
  gem 'inspec', '>= 2.0'
  gem 'kitchen-digitalocean'
  gem 'kitchen-docker'
  gem 'kitchen-inspec'
  gem 'kitchen-vagrant'
  gem 'test-kitchen'
end

group :testing do
  gem 'kitchen-ansiblepush'
  gem 'net-ssh'
end
