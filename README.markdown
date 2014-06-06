####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with jenkins_job_builder](#setup)
    * [What jenkins_job_builder affects](#what-jenkins_job_builder-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with jenkins_job_builder](#beginning-with-jenkins_job_builder)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

Install [jenkins_job_builder](ci.openstack.org/jenkins-job-builder/) to allow you to manage your Jenkins jobs  

[![Build
Status](https://secure.travis-ci.org/opentable/puppet-jenkins_job_builder.png)](https://secure.travis-ci.org/opentable/puppet-jenkins_job_builder.png)

##Module Description

The openstack jenkins_job_builder tool manages the configuration of jobs in your Jenkins instance. This module wraps that tool and allows you to control
all the configuration of your Jenkins jobs from within hiera.

##Setup

###What jenkins_job_builder affects

* Install the jenkins_job_builder pip package
* Creates temporary files for each jenkins job you want to manage

###Beginning with jenkins_job_builder

Installing jenkins_job_builder to a specified version

```puppet
class { 'jenkins_job_builder':
  version => 'latest'
}
```

##Usage

###Classes and Defined Types

####Class: `jenkins_job_builder`

**Parameters within `jenkins_job_builder`:**
####`version`
The version of the the plugin to be installed.

####`jobs`
A hash of the configuration for all the jobs you want to configure in your Jenkins instance.

####`user`
The user used to authenticate to the Jenkins instance.

####`password`
The password used to authenticate to the Jenkins instance.

####`hipchat_token`
If using the jenkins hipchat plugin, this is the token that should be specified in the global config.

####`jenkins_url`
The full url (including port) to the jenkins instance.

#####Define: `jenkins_job_builder::job`

**Parameters within `jenkins_job_builder::job`:**
####`config`
A hash of the configuration for all the job you want to configure in your Jenkins instance.

####`delay`
The time (in seconds) to delay the creatation of the Jenkins job. This is to avoid issues where Jenkins restarts during a puppet run.

##Reference

###Classes
####Public Classes
* [`jenkins_job_builder`](#class-jenkins_job_builder): Guides the installation of jenkins_job_builder
####Definitions
* [`jenkins_job_builder::job`](#define-job): Manages the configuration of a Jenkins job

##Limitations

This module is tested on the following platforms:

* CentOS 5
* CentOS 6
* Ubuntu 10.04.4
* Ubuntu 12.04.2
* Ubuntu 13.10

It is tested with the OSS version of Puppet only.

##Development

###Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.

###Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/) and [beaker](https://github.com/puppetlabs/beaker) to verify functionality. For in-depth information please see their respective documentation.

Quickstart:

    gem install bundler
    bundle install
    bundle exec rake spec
	BEAKER_DEBUG=yes bundle exec rspec spec/acceptance