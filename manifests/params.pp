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

}