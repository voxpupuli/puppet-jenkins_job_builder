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
# [*service_name*]
# The name of the jenkins service to restart when configuration changes are made
#
# [*job_yaml*]
# Include this content as raw yaml for the job
#
# [*jobs*]
# Used if sourcing multiple jobs, templates are broken into smaller parts, etc. This enables recursion.
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
  $delay = 0,
  $service_name = 'jenkins',
  $job_yaml = '',
  $jobs = undef,
  $tries = '5',
  $try_sleep = '15',
  $jenkins_job_dir = '/var/lib/jenkins/jobs',
  $idempotence = false,
) {

  if $delay != 0 {
    notice('The delay parameter has been replaced by retry functionality, and will be removed in a future release')
  }

  $jjb_prefix = "/bin/sleep ${delay} && /usr/local/bin/jenkins-jobs --ignore-cache --conf /etc/jenkins_jobs/jenkins_jobs.ini"

  if $jobs {
    if $idempotence {
      fail('Cannot use idempotent operation when sourcing a jobs directory')
    }
    $jjbcmd  = "${jjb_prefix} update -r ${jobs}"
  } else {
    if $config != {} {
      $content = template('jenkins_job_builder/jenkins-job-yaml.erb')
    } else {
      $content = $job_yaml
    }
    file { "/tmp/jenkins-${name}.yaml":
      ensure  => present,
      content => $content,
      notify  => Exec["manage jenkins job - ${name}"],
    }
    $jjbcmd = "${jjb_prefix} update /tmp/jenkins-${name}.yaml"
  }

  if $idempotence {
    $xmllint_cmd = '/bin/xmllint --c14n'
    $unless_cmd  = "/bin/bash -c '/bin/diff <(${xmllint_cmd} ${jenkins_job_dir}/${name}/config.xml || echo '') <(${jjb_prefix} test /tmp/jenkins-${name}.yaml|${xmllint_cmd} - )'"
    $refreshonly = undef
  } else {
    $unless_cmd  = undef
    $refreshonly = true
  }

  exec { "manage jenkins job - ${name}":
    command     => $jjbcmd,
    refreshonly => $refreshonly,
    unless      => $unless_cmd,
    tries       => $tries,
    try_sleep   => $try_sleep,
    require     => Service[$service_name],
  }

}
