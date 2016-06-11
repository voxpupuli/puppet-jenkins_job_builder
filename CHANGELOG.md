##2016-06-08 - Release 2.0.0
###Summary

  - Issue #17, Make install source configurable
  - Issue #18, use to_yaml methods instead of sort_yaml method (potentially breaking change).
  - Issue #21, Job creation retry implementation
  - Issue #31, Support for sourcing jobs
  - add capability to install job_builder from git
  - removing argparse dependency for debian

##2014-10-24 - Release 1.1.0
###Summary

  This releases focuses on fixing some minor bugs and also adds support for supply your own configuration yaml

####Features

  - new parameter `job_yaml` to include the yaml configuration for a job in it's raw format and not be generated
  by the module. This is useful when when dealing with large complex jobs. (#8)

####Bugfixes

  - add missing inifile dependency into metadata.json
  - fixes bug in the yaml template not generating the correct yaml configuration (#7)

##2014-10-10 - Release 1.0.0
###Summary

  This release focuses on improving the testing and documentation of the module. It also contains a number of small bugfixes

####Features
 - Adding new parameter `service_name` to the job definition to better support when jenkins is installed in an app server like tomcat
 - Improved documentation
 - Improved tests

####Bugfixes
 - Fix missing '-job' keyword in yaml template
 - Added missing python-argparse dependency

##2014-06-13 - Release 0.1.1
###Summary
  This release fixes some bugs in the yaml file

####Bugfixes

- fixed bug with double quote escaping causing and invalid yaml file

##2014-06-06 - Release 0.1.0
###Summary

  Initial release. Supports installing jenkins_job_builder package and managing jobs with yaml
