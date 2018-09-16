describe port(3306) do
  it { should be_listening }
  its('processes') { should include 'mysqld' }
  its('protocols') { should include 'tcp' }
  its('protocols') { should_not include('udp') }
  its('addresses') { should_not include '0.0.0.1' }
  its('addresses') { should_not include '0.0.0.0' }
end
