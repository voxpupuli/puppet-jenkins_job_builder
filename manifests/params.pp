# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class jenkins_job_builder::params
#
# This class is meant to be called from jenkins_job_builder
# It sets the default paramters based upon operating system
#
class jenkins_job_builder::params {

  $jobs = {}
  $user = ''
  $password = ''
  $timeout = undef
  $hipchat_token = ''
  $jenkins_url = 'http://localhost:8080'
  $version = 'latest'
  $service = 'jenkins'
  $install_from_git = false
  $install_from_pip = true
  $install_from_pkg = false
  $git_revision     = 'master'
  $git_url          = 'https://git.openstack.org/openstack-infra/jenkins-job-builder'

  case $::osfamily {
    'RedHat', 'Amazon': {
      if $::operatingsystemrelease =~ /^6/ {
        $python_packages = [ 'python', 'python-devel', 'python-pip', 'python-argparse', 'PyYAML']
        # This requires the dcaro/jenkins-job-builder repository
        $jjb_packages    = [ 'jenkins-job-builder']
      } else {
        $python_packages = [ 'python', 'python-devel', 'python2-pip', 'PyYAML']
        $jjb_packages    = [ 'python-jenkins-job-builder']
      }
    }
    'debian': {
      $python_packages = [ 'python', 'python-dev', 'python-pip', 'python-argparse', 'python-yaml' ]
      $jjb_packages    = [ 'jenkins-job-builder']
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

}
