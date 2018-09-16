# frozen_string_literal: true

skiplist = attribute('skiplist',
                     description: 'list of controls to skip',
                     default: ['mysql-skip-this'],
                     required: true)

# my_services = yaml(content: inspec.profile.file('services.yml')).params
vars_json = json('/var/cache/ansible/attributes/hostvars.json')
vars = vars_json.params

mysql_ver = vars['mysql_requested_version']

control 'check-attributes' do
  impact 0.6
  title "Check attribtues for node: #{vars['ansible_hostname']}"
  desc ' Prevent unexpected settings.  '
  describe file('/var/cache/ansible/attributes/hostvars.json') do
    it { should exist }
    #  its('mode') { should cmp 0644 }
  end
end
# https://www.inspec.io/docs/reference/resources/mysql_session/

control 'mysql-1' do
  impact 0.6
  title 'MySQL Checks'
  desc ' '

  describe service(vars['mysql_service_name']) do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end

  describe port(3306) do
    it { should be_listening }
  end

  sql = mysql_session(vars['mysql_root_user'], vars['mysql_root_password'])

  describe sql.query('show databases;') do
    its('stdout') { should match(/mysql/) }
  end

  cmd_stderr = sql.query('show databases;').stderr

  describe cmd_stderr.sub(/^(.+?Using a password on the command line interface can be insecure.+?\n)/, '') || cmd_stderr do
    it { should eq '' }
  end
end

control 'mysql-versioning-1' do
  impact 0.6
  title 'MySQL Checks'
  desc '   Determine whether configuration and versions are correct  '

  describe(mysql_ver).to_s.empty? do
    it { should_not eq true }
  end

  describe command('mysql -V') do
    its('stdout') { should match(/#{mysql_ver}/) }
  end

  sql = mysql_session(vars['mysql_root_user'], vars['mysql_root_password'])

  describe command('mysqladmin --version') do
    its('stdout') { should match(/#{mysql_ver}/) }
  end

  describe sql.query("SHOW VARIABLES LIKE 'version';") do
    its('stdout') { should match(/#{mysql_ver}/) }
  end
end

control 'mysql-data-definition-statements-1' do
  impact 0.6
  title 'MySQL Data Definition Statements'
  desc '   Verify database, table, stored procedure CREATE, ALTER, DELETE  '

  sql_data_def = mysql_session(vars['mysql_root_user'], vars['mysql_root_password'])

  describe sql_data_def.query('CREATE DATABASE testdb_inspec;') do
    # its('stdout') { should match(/Query OK, 1 row affected/) }
    # its('stderr') { should cmp '' }
    its('exit_status') { should eq(0) }
  end

  describe sql_data_def.query('DROP DATABASE testdb_inspec;') do
    # its('stdout') { should match(/Query OK, 1 row affected/) }
    # its('stderr') { should cmp '' }
    its('exit_status') { should eq(0) }
  end

  describe command('mysqladmin --version') do
    its('stdout') { should match(/#{mysql_ver}/) }
  end

  #   describe sql.query(%q{CREATE TABLE `testdb`.`auditlog_details` (
  #   `auditdetailid` bigint(20) unsigned NOT NULL,
  #   `auditid` bigint(20) unsigned NOT NULL,
  #   `table_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  # ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin}) do
  #     # its('stdout') { should match(/#{mysql_ver['requested_version']}/) }
  #   end
end

control 'mysql-skip-this' do
  impact 0.6
  title 'MySQL Checks'
  desc "this test should fail, it's here to test the skip feature"
  describe command('mysql -V') do
    its('stdout') { should match(/fweffewfe/) }
  end
end

skiplist.each do |skip|
  skip_control skip
end
