# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class: jenkins_job_builder
#
# The purpose of this module is to install the jenkins_job_builder tool to manage jenkins jobs
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*version*]
# The version of jenkins_job_builder to be installed.
#
# [*jobs*]
# A hash of the configuration for all the jobs you want to configure in your Jenkins instance.
#
# [*user*]
# The user used to authenticate to the Jenkins instance.
#
# [*password*]
# The password used to authenticate to the Jenkins instance.
#
# [*hipchat_token*]
# If using the jenkins hipchat plugin, this is the token that should be specified in the global config.
#
# [*jenkins_url*]
# The full url (including port) to the jenkins instance.
#
#  === Examples
#
# Installing jenkins_job_builder to a specified version
#
# class { 'jenkins_job_builder':
#   version => 'latest'
# }
#
class jenkins_job_builder(
  $version          = $jenkins_job_builder::params::version,
  $jobs             = $jenkins_job_builder::params::jobs,
  $user             = $jenkins_job_builder::params::user,
  $password         = $jenkins_job_builder::params::password,
  $hipchat_token    = $jenkins_job_builder::params::hipchat_token,
  $jenkins_url      = $jenkins_job_builder::params::jenkins_url,
  $service          = 'jenkins',
  $install_from_git = $jenkins_job_builder::params::install_from_git,
  $git_revision     = $jenkins_job_builder::params::git_revision,
  $git_url          = $jenkins_job_builder::params::git_url,

) inherits jenkins_job_builder::params {

  validate_re($::osfamily,'RedHat|Debian',"${::osfamily} not supported")
  validate_hash($jobs)
  validate_string($user)
  validate_string($password)
  validate_string($hipchat_token)
  validate_string($jenkins_url)
  validate_string($version)
  validate_string($git_revision)
  validate_string($git_url)
  validate_bool($install_from_git)

  class {'jenkins_job_builder::install': } ->
  class {'jenkins_job_builder::config': } ->
  Class['jenkins_job_builder']
}
