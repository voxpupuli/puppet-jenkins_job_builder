require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  install_puppet
end

UNSUPPORTED_PLATFORMS = ['Suse','windows','AIX','Solaris']

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    puppet_module_install(:source => proj_root, :module_name => 'jenkins_job_builder')
    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-inifile'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','rtyler-jenkins'), { :acceptable_exit_codes => [0,1] }

      on host, 'mkdir /etc/puppet/hiera'
      scp_to host, File.join(File.dirname(__FILE__),  'hiera.yaml'), '/etc/puppet/hiera.yaml'
      scp_to host, File.join(File.dirname(__FILE__),  'global.yaml'), '/etc/puppet/hiera/global.yaml'
    end
  end
end