# frozen_string_literal: true
require 'spec_helper'

describe 'jenkins_job_builder' do
  context 'supported operating systems' do
    %w(Debian RedHat).each do |osfamily|
      describe "jenkins_job_builder class without any parameters on #{osfamily}" do
        let(:params) { {} }
        let :facts do
          {
            osfamily: osfamily,
            operatingsystemrelease: '6'
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('jenkins_job_builder::params') }

        it { is_expected.to contain_class('jenkins_job_builder::install').that_comes_before('class[jenkins_job_builder::config]') }
        it { is_expected.to contain_class('jenkins_job_builder::config') }

        it { is_expected.to contain_package('jenkins-job-builder').with_ensure('latest') }

        it { is_expected.to contain_file('/etc/jenkins_jobs').with_ensure('directory') }
        it { is_expected.to contain_file('/etc/jenkins_jobs/jenkins_jobs.ini').with_ensure('present') }

        it do
          is_expected.to contain_ini_setting('jenkins-jobs user').with(
            'ensure'  => 'present',
            'path'    => '/etc/jenkins_jobs/jenkins_jobs.ini',
            'section' => 'jenkins',
            'setting' => 'user',
            'value'   => '',
            'require' => 'File[/etc/jenkins_jobs/jenkins_jobs.ini]'
          )
        end

        it do
          is_expected.to contain_ini_setting('jenkins-jobs password').with(
            'ensure'  => 'present',
            'path'    => '/etc/jenkins_jobs/jenkins_jobs.ini',
            'section' => 'jenkins',
            'setting' => 'password',
            'value'   => '',
            'require' => 'File[/etc/jenkins_jobs/jenkins_jobs.ini]'
          )
        end

        it do
          is_expected.to contain_ini_setting('jenkins-jobs url').with(
            'ensure'  => 'present',
            'path'    => '/etc/jenkins_jobs/jenkins_jobs.ini',
            'section' => 'jenkins',
            'setting' => 'url',
            'value'   => 'http://localhost:8080',
            'require' => 'File[/etc/jenkins_jobs/jenkins_jobs.ini]'
          )
        end

        it do
          is_expected.to contain_ini_setting('jenkins-jobs hipchat token').with(
            'ensure'  => 'present',
            'path'    => '/etc/jenkins_jobs/jenkins_jobs.ini',
            'section' => 'hipchat',
            'setting' => 'authtoken',
            'value'   => '',
            'require' => 'File[/etc/jenkins_jobs/jenkins_jobs.ini]'
          )
        end
      end
    end

    describe "jenkins_job_builder class without any parameters on a 'Debian' OS" do
      let(:params) { {} }
      let :facts do
        {
          osfamily: 'Debian',
          operatingsystemrelease: 'should_not_be_used'
        }
      end

      ['python', 'python-pip', 'python-yaml'].each do |dep|
        it { is_expected.to contain_package(dep).with_ensure('present') }
      end
    end

    describe "jenkins_job_builder class without any parameters on a 'RedHat' OS version 6" do
      let(:params) { {} }
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '6'
        }
      end

      ['python', 'python-pip', 'PyYAML', 'python-argparse'].each do |dep|
        it { is_expected.to contain_package(dep).with_ensure('present') }
      end
    end

    describe "jenkins_job_builder class without any parameters on a 'RedHat' OS" do
      let(:params) { {} }
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '7'
        }
      end

      ['python', 'python2-pip', 'PyYAML'].each do |dep|
        it { is_expected.to contain_package(dep).with_ensure('present') }
      end
    end
  end

  context 'install from git' do
    describe 'jenkins_job_builder installed from git' do
      let :params do
        {
          install_from_git: true
        }
      end
      let(:facts) do
        {
          osfamily: 'Debian',
          operatingsystemrelease: 'should_not_be_used'
        }
      end

      it do
        is_expected.to contain_vcsrepo('/opt/jenkins_job_builder').with(
          'ensure'   => 'latest',
          'provider' => 'git'
        )
      end
    end
  end

  context 'install from pkg' do
    describe "jenkins_job_builder installed from pkg on 'Debian' OS" do
      let :params do
        {
          install_from_pkg: true
        }
      end
      let(:facts) do
        {
          osfamily: 'Debian',
          operatingsystemrelease: 'should_not_be_used'
        }
      end

      it { is_expected.to contain_package('jenkins-job-builder').with_ensure('latest') }
    end
    describe "jenkins_job_builder installed from pkg on 'RedHat' OS version el6" do
      let :params do
        {
          install_from_pkg: true
        }
      end
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '6'
        }
      end

      it { is_expected.to contain_package('jenkins-job-builder').with_ensure('latest') }
    end
    describe "jenkins_job_builder installed from pkg on 'RedHat' OS" do
      let :params do
        {
          install_from_pkg: true
        }
      end
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '7'
        }
      end

      it { is_expected.to contain_package('python-jenkins-job-builder').with_ensure('latest') }
    end
  end

  context 'explicit timeout value' do
    describe 'jenkins_job_builder with timeout value specified' do
      let :params do
        {
          timeout: '25'
        }
      end
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '7'
        }
      end

      it do
        is_expected.to contain_ini_setting('jenkins-jobs timeout').with(
          'ensure'  => 'present',
          'path'    => '/etc/jenkins_jobs/jenkins_jobs.ini',
          'section' => 'jenkins',
          'setting' => 'timeout',
          'value'   => 25,
          'require' => 'File[/etc/jenkins_jobs/jenkins_jobs.ini]'
        )
      end
    end
  end

  context 'unsupported operating system' do
    describe 'jenkins_job_builder class without any parameters on Solaris/Nexenta' do
      let :facts do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Nexenta',
          operatingsystemrelease: 'should_not_be_used'
        }
      end

      it { expect { is_expected.to contain_package('jenkins_job_builder') }.to raise_error(Puppet::Error, %r{Nexenta not supported}) }
    end
  end

  context 'creates jobs' do
    describe 'jenkins_job_builder with a hash of jobs' do
      let :params do
        {
          jobs: {
            'test01' => {
              'config' => {
                'name'        => 'test01',
                'description' => 'the first jenkins job'
              }
            },
            'test02' => {
              'config' => {
                'name'        => 'test02',
                'description' => 'the second jenkins job'
              }
            }
          }
        }
      end
      let :facts do
        {
          osfamily: 'Debian',
          operatingsystemrelease: 'should_not_be_used'
        }
      end

      it do
        is_expected.to contain_file('/tmp/jenkins-test01.yaml').with(
          'content' => ['job' => params[:jobs]['test01']['config']].to_yaml
        )
      end

      it do
        is_expected.to contain_file('/tmp/jenkins-test02.yaml').with(
          'content' => ['job' => params[:jobs]['test02']['config']].to_yaml
        )
      end
    end
  end
end
