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
  $hipchat_token = ''
  $jenkins_url = 'http://localhost:8080'
  $version = 'latest'
  $service = 'jenkins'

  case $::osfamily {

    'RedHat', 'Amazon': {
      if '7' == $operatingsystemmajrelease {
        $python_packages =  [ 'python', 'python-devel', 'python-pip' ]
      } else {
        $python_packages = [ 'python', 'python-dev', 'python-pip', 'python-argparse' ]
      }
    }

    'Debian': {
      $python_packages = [ 'python', 'python-dev', 'python-pip' ]
    }

    default: {
      fail("${::operatingsystem} not supported")
    }
  }

}
