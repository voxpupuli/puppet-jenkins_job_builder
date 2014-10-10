# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Define: jenkins_job_builder::job
#
# The purpose of this defintion is to manage the configuration of a single Jenkins job.
#
# === Parameters
#
# [*config*]
# A hash of the configuration for all the job you want to configure in your Jenkins instance.
#
# [*delay*]
# The time (in seconds) to delay the creatation of the Jenkins job. This is to avoid issues where Jenkins restarts during a puppet run.
#
#  === Examples
#
# Installing jenkins_job_builder::job to configure a job
#
# $job = {
#   'config' => {
#     'name'         => 'test-job',
#     'description'  => 'This is a test job',
#     'project-type' => 'freestyle',
#     'scm'          => [
#       'git' => {
#         'url'      => 'git@github.com:opentable/puppet-jenkins_job_builder',
#         'branches' => ['*/master']
#       }
#     ],
#     'builders' => [
#       'shell' => 'echo hello'
#     ],
#     'triggers' => [
#       'pollscm' => '*/1 * * * *'
#     ]
#   }
# }
#
# class { 'jenkins_job_builder':
#   config => $job
# }
#
define jenkins_job_builder::job (
  $config = {},
  $delay = 0
) {

  file { "/tmp/jenkins-${name}.yaml":
    ensure  => present,
    content => template('jenkins_job_builder/jenkins-job-yaml.erb'),
    notify  => Exec["manage jenkins job - ${name}"]
  }

  exec { "manage jenkins job - ${name}":
    command     => "/bin/sleep ${delay} && /usr/local/bin/jenkins-jobs --ignore-cache --conf /etc/jenkins_jobs/jenkins_jobs.ini update /tmp/jenkins-${name}.yaml",
    refreshonly => true,
    require     => Service[$jenkins_job_builder::service]
  }

}
