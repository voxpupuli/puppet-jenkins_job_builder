# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class jenkins_job_builder::install
#
# This class is meant to be called from jenkins_job_builder
# It installs the pip package and all required dependencies
#
class jenkins_job_builder::install(
  $version          = $jenkins_job_builder::version,
  $install_from_git = $jenkins_job_builder::install_from_git,
  $git_url          = $jenkins_job_builder::git_url,
  $git_revision     = $jenkins_job_builder::git_revision,
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ensure_resource('package', $jenkins_job_builder::params::python_packages, { 'ensure' => 'present' })
  ensure_resource('package', 'pyyaml', { 'ensure' => 'present', 'provider' => 'pip', 'require' => 'Package[python]'})

  if $install_from_git {

    vcsrepo { '/opt/jenkins_job_builder':
      ensure   => latest,
      provider => git,
      revision => $git_revision,
      source   => $git_url,
    }

    exec { 'install_jenkins_job_builder':
      command     => 'pip install /opt/jenkins_job_builder',
      path        => '/usr/local/bin:/usr/bin:/bin/',
      refreshonly => true,
      subscribe   => Vcsrepo['/opt/jenkins_job_builder'],
    }

  } else {

    package { 'jenkins-job-builder':
      ensure   => $version,
      provider => 'pip'
    }

  }
}
