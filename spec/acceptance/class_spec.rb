require 'spec_helper_acceptance'
include Beaker::HostPrebuiltSteps

describe 'jenkins_job_builder class' do

  context 'with a defined job' do
    it 'should work with no errors' do

      pp = <<-EOS
      class { 'jenkins': } ->
      class { 'jenkins_job_builder': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('jenkins-job-builder') do
      it { should be_installed.by('pip') }
    end

    #TODO: test ini file

    yaml_content = <<-'YAML'
---
  - job:
       description: "This a test job"
       name: "test"
       project-type: "freestyle"
       scm:
        - git:
           branches:
             - "*/master"
           builders:
            - shell: "#!/bin/bash -l\necho \"test\"\n"
           triggers:
            - pollscm: "*/1 * * * *"
           url: "git@github.com:opentable/puppet-jenkins_job_builder"
YAML

    describe file('/tmp/jenkins-test.yaml') do
      it { should be_file }
      its(:content) { should == yaml_content }
    end
  end
end
