# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class jenkins_job_builder::install
#
# This class is meant to be called from jenkins_job_builder
# It installs the pip package and all required dependencies
#
class jenkins_job_builder::install(
  $version = $jenkins_job_builder::version
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_resource('package', $jenkins_job_builder::params::python_packages, { 'ensure' => 'present' })
  ensure_resource('package', 'pyyaml', { 'ensure' => 'present', 'provider' => 'pip', 'require' => $jenkins_job_builder::params::python_packages })

  package { 'jenkins-job-builder':
    ensure   => $version,
    provider => 'pip'
  }
}
