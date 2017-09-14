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
# The user used to authenticate to the Jenkins instance. (optional)
#
# [*password*]
# The password used to authenticate to the Jenkins instance. (optional)
#
# [*timeout*]
# The connection timeout (in seconds) to the Jenkins server.
#
# [*hipchat_token*]
# If using the jenkins hipchat plugin, this is the token that should be specified in the global config.
#
# [*jenkins_url*]
# The full url (including port) to the jenkins instance.
#
# [*install_from_git*]
# Boolean, defaults to false. This will install JJB itself from git, but system pkgs will satisfy dependencies.
# The behavior when install_from_git and install_from_pkg are false is to install from pip
#
# [*install_from_pkg*]
# Boolean, defaults to false. Only allow system packages to satisfy installation sources. Useful for some environments that require this.
# The behavior when install_from_git and install_from_pkg are false is to install from pip
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
  $version                   = $jenkins_job_builder::params::version,
  Hash $jobs                 = $jenkins_job_builder::params::jobs,
  Optional[String] $user     = $jenkins_job_builder::params::user,
  Optional[String] $password = $jenkins_job_builder::params::password,
  Optional[Integer] $timeout = $jenkins_job_builder::params::timeout,
  String $hipchat_token      = $jenkins_job_builder::params::hipchat_token,
  String $jenkins_url        = $jenkins_job_builder::params::jenkins_url,
  String $service            = 'jenkins',
  Boolean $install_from_git  = $jenkins_job_builder::params::install_from_git,
  Boolean $install_from_pkg  = $jenkins_job_builder::params::install_from_pkg,
  String $git_revision       = $jenkins_job_builder::params::git_revision,
  String $git_url            = $jenkins_job_builder::params::git_url,

) inherits jenkins_job_builder::params {

  if count([$install_from_git, $install_from_pkg], true) > 1 {
    fail("A single primary install source must be selected for ${name}")
  }

  class {'::jenkins_job_builder::install': }
  -> class {'::jenkins_job_builder::config': }
  -> Class['jenkins_job_builder']
}
