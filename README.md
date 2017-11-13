# Jenkins Job Builder module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-jenkins_job_builder.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-jenkins_job_builder)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-jenkins_job_builder/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-jenkins_job_builder)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/jenkins_job_builder.svg)](https://forge.puppetlabs.com/puppet/jenkins_job_builder)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/jenkins_job_builder.svg)](https://forge.puppetlabs.com/puppet/jenkins_job_builder)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/jenkins_job_builder.svg)](https://forge.puppetlabs.com/puppet/jenkins_job_builder)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/jenkins_job_builder.svg)](https://forge.puppetlabs.com/puppet/jenkins_job_builder)

#### Table of Contents

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

## Overview

Install [jenkins_job_builder](ci.openstack.org/jenkins-job-builder/) to allow you
to manage your Jenkins jobs.

## Module Description

The openstack jenkins_job_builder tool manages the configuration of jobs in your
Jenkins instance. This module wraps that tool and allows you to control all the
configuration of your Jenkins jobs from within hiera.

## Setup

### What jenkins_job_builder affects

* Install the jenkins_job_builder pip package
* Creates temporary files for each jenkins job you want to manage

### Beginning with jenkins_job_builder

Installing jenkins_job_builder to a specified version

```puppet
class { 'jenkins_job_builder':
  version => 'latest'
}
```

## Usage

### Classes and Defined Types

#### Class: `jenkins_job_builder`

**Parameters within `jenkins_job_builder`:**

#### `version`

The version of the the plugin to be installed.

#### `jobs`

A hash of the configuration for all the jobs you want to configure in your
Jenkins instance.

#### `user`

The user used to authenticate to the Jenkins instance. (optional)

#### `password`

The password used to authenticate to the Jenkins instance. (optional)

#### `timeout`

(Optional) The connection timeout (in seconds) to the Jenkins server. If `timeout`
is unset it will remove any existing timeout values in the config file.

#### `hipchat_token`

If using the jenkins hipchat plugin, this is the token that should be specified
in the global config.

#### `jenkins_url`

The full url (including port) to the jenkins instance.

##### Define: `jenkins_job_builder::job`

**Parameters within `jenkins_job_builder::job`:**

#### `config`

A hash of the configuration for all the job you want to configure in your
Jenkins instance.

#### `delay`

The time (in seconds) to delay the creatation of the Jenkins job. This is to
avoid issues where Jenkins restarts during a puppet run.

#### `service_name`

The name of the jenkins service to restart when configuration changes are made.
Defaults to 'jenkins'

## Reference

### Classes

#### Public Classes

* [`jenkins_job_builder`](#class-jenkins_job_builder): Guides the installation
  of jenkins_job_builder

#### Definitions

* [`jenkins_job_builder::job`](#define-job): Manages the configuration of a
  Jenkins job

## Limitations

This module is tested on the following platforms:

* CentOS 5
* CentOS 6
* Ubuntu 13.10
* Ubuntu 14.04

It is tested with the OSS version of Puppet only.

## Development

### Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.
