# frozen_string_literal: true

require 'spec_helper'

describe 'jenkins_job_builder::job', type: :define do
  let(:pre_condition) do
    [
      'include jenkins_job_builder',
      "service { 'jenkins': }"
    ]
  end
  let(:facts) { { osfamily: 'Debian' } }

  context 'supported operating systems' do
    %w[Debian RedHat].each do |osfamily|
      describe "jenkins_job_builder::job define without any parameters on #{osfamily}" do
        let(:title) { 'test' }
        let :facts do
          {
            osfamily: osfamily,
            operatingsystemrelease: '6'
          }
        end

        it { is_expected.to contain_file('/tmp/jenkins-test.yaml') }

        it { is_expected.to contain_file('/tmp/jenkins-test.yaml').with_content('') }

        it do
          is_expected.to contain_exec('manage jenkins job - test').with(
            'command' => '/bin/sleep 0 && /usr/local/bin/jenkins-jobs --ignore-cache --conf /etc/jenkins_jobs/jenkins_jobs.ini update /tmp/jenkins-test.yaml',
            'refreshonly' => 'true',
            'require' => 'Service[jenkins]',
            'tries' => '5',
            'try_sleep' => '15'
          )
        end
      end
    end
  end

  context 'supported operating systems - params' do
    describe 'increased delay' do
      let(:title) { 'test' }
      let(:params) do
        {
          'delay' => '5'
        }
      end

      it do
        is_expected.to contain_exec('manage jenkins job - test').with(
          'command' => '/bin/sleep 5 && /usr/local/bin/jenkins-jobs --ignore-cache --conf /etc/jenkins_jobs/jenkins_jobs.ini update /tmp/jenkins-test.yaml'
        )
      end
    end

    describe 'with retry mechanism' do
      let(:title) { 'test' }
      let(:params) do
        {
          'tries' => '10',
          'try_sleep' => '45'
        }
      end

      it do
        is_expected.to contain_exec('manage jenkins job - test').with(
          'command' => '/bin/sleep 0 && /usr/local/bin/jenkins-jobs --ignore-cache --conf /etc/jenkins_jobs/jenkins_jobs.ini update /tmp/jenkins-test.yaml',
          'tries' => '10',
          'try_sleep' => '45'
        )
      end
    end

    describe 'with idempotence enabled' do
      let(:title) { 'test' }
      let(:params) do
        {
          'idempotence' => true
        }
      end

      it do
        is_expected.to contain_exec('manage jenkins job - test').with(
          'command' => '/bin/sleep 0 && /usr/local/bin/jenkins-jobs --ignore-cache --conf /etc/jenkins_jobs/jenkins_jobs.ini update /tmp/jenkins-test.yaml',
          'unless'  => "/bin/bash -c '/bin/diff <(/bin/xmllint --c14n /var/lib/jenkins/jobs/test/config.xml || echo '') <(/bin/sleep 0 && /usr/local/bin/jenkins-jobs --ignore-cache --conf /etc/jenkins_jobs/jenkins_jobs.ini test /tmp/jenkins-test.yaml|/bin/xmllint --c14n - )'"
        )
      end
    end

    describe 'custom config' do
      let(:title) { 'test' }
      let(:params) do
        {
          'config' => { 'name' => 'test' }
        }
      end

      it do
        is_expected.to contain_file('/tmp/jenkins-test.yaml').with(
          'content' => ['job' => params['config']].to_yaml
        )
      end
    end

    describe 'job yaml' do
      let(:title) { 'test' }
      let(:params) do
        {
          'job_yaml' => "---\n- job:\n  name: test\n"
        }
      end

      it do
        is_expected.to contain_file('/tmp/jenkins-test.yaml').with(
          'content' => "---\n- job:\n  name: test\n"
        )
      end
    end
  end
end
