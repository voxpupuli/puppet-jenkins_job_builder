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

  ensure_resource('package', ['python', 'python-dev', 'python-pip'], { 'ensure' => 'present' })
  ensure_resource('package', 'pyyaml', { 'ensure' => 'present', 'provider' => 'pip', 'require' => 'Package[python]'})

  package { 'jenkins-job-builder':
    ensure   => $version,
    provider => 'pip'
  }
}