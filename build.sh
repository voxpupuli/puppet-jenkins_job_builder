#!/usr/bin/env sh

bundle exec rake test

BEAKER_set=ubuntu-server-12042-x64 BEAKER_debug=yes bundle exec rspec spec/acceptance
BEAKER_set=ubuntu-server-1310-x64 BEAKER_debug=yes bundle exec rspec spec/acceptance

BEAKER_set=centos-510-x64 BEAKER_debug=yes bundle exec rspec spec/acceptance
BEAKER_set=centos-64-x64 BEAKER_debug=yes bundle exec rspec spec/acceptance
