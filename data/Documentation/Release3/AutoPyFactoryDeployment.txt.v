head	1.1;
access;
symbols;
locks; strict;
comment	@# @;


1.1
date	2015.08.28.18.58.55;	author KyleGross;	state Exp;
branches;
next	;


desc
@none
@


1.1
log
@none
@
text
@%META:TOPICINFO{author="KyleGross" date="1440788335" format="1.1" reprev="1.1" version="1.1"}%
*WARNING: THIS DOCUMENTATION IS WORK IN PROGRESS!!!!!*

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;width:100%}
.tg td{font-family:Arial, sans-serif;font-size:12px;padding:5px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
.tg th{font-family:Arial, sans-serif;font-size:12px;font-weight:normal;padding:5px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
.tg .tg-raw1{font-weight:bold;color:#0055ff;text-align:left}
.tg .tg-header{font-weight:bold;background-color:#c0c0c0;text-align:center}
.tg .tg-splitheader{font-weight:bold;background-color:#e0e0e0;text-align:center}
</style>


<!-- some useful definitions  (need 3 white spaces before * to enable it)
   * Set UCL_PROMPT_ROOT = [root@@factory ~]$
   * Set VERSION = 2.4.5
-->

---+!! Deployment of !AutoPyFactory
<!--
%DOC_STATUS_TABLE%
-->
%TOC{depth="3"}%

---# About this Document

This document describes how to install and configure AutoPyFactory

%INCLUDE{"Documentation/DocumentationTeam/DocConventions" section="Header"}%
%INCLUDE{"Documentation/DocumentationTeam/DocConventions" section="CommandLine"}%

%STARTSECTION{"Version"}%
---# Applicable versions
This document explains how to install and configure latest version of APF: %VERSION%
%ENDSECTION{"Version"}%

---# Deployment using RPM

Installation as root via RPMs has now been quite simplified. These instructions assume Red Hat /
Enterprise Linux 6.x (and derivates) and the system Python 2.6.x. Other distros and higher 
Python versions should work with some extra work. 

1) Install and enable a supported batch system. Condor is the current supported default. /
Software available from  http://www.cs.wisc.edu/condor/. Condor/Condor-G setup and 
configuration is beyond the scope of this documentation. Ensure that it is working
properly before proceeding. 

2) Install a grid client and set up the grid certificate+key under the user APF will run as. 
See  [[#4_2_sysconfig_autopyfactory][sysconfig section]] for details.
Please read the section [[#4_4_proxy_conf][proxy.conf]] regarding the proxy.conf file, so you see what 
will be needed. Make sure voms-proxy-* commands work properly. 

3) We distribute now !AutoPyFactory RPMs using the Open Science Grid (OSG) yum infrastructure. 
Install the OSG yum repo files:

<pre class="rootscreen">
%UCL_PROMPT_ROOT% rpm -Uhv  http://repo.grid.iu.edu/osg/3.2/osg-3.2-el6-release-latest.rpm
Retrieving http://repo.grid.iu.edu/osg/3.2/osg-3.2-el6-release-latest.rpm
Preparing...                ########################################### [100%]
   1:osg-release            ########################################### [100%]
</pre>

More extensive documentation on how to install the OSG yum files can be found [[https://twiki.grid.iu.edu/bin/view/Documentation/Release3/YumRepositories][here]].
                                                  
*IMPORTANT*: due the internal OSG yum repositories architecture, the AutoPyFactory RPMs are currently being distributed via the development repo. 
Therefore, you may want to enabled it, as it is disabled by default, by setting ==enabled=1== in the file =/etc/yum.repos.dosg-el6-development.repo/=:

<pre class="file">
[osg-development]
name=OSG Software for Enterprise Linux 6 - Development - $basearch
#baseurl=http://repo.grid.iu.edu/osg/3.2/el6/development/$basearch
mirrorlist=http://repo.grid.iu.edu/mirror/osg/3.2/el6/development/$basearch
failovermethod=priority
priority=98
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
consider_as_osg=yes

[osg-development-source]
name=OSG Software for Enterprise Linux 6 - Development - $basearch - Source
baseurl=http://repo.grid.iu.edu/osg/3.2/el6/development/source/SRPMS
failovermethod=priority
priority=98
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG

[osg-development-debuginfo]
name=OSG Software for Enterprise Linux 6 - Development - $basearch - Debug
baseurl=http://repo.grid.iu.edu/osg/3.2/el6/development/$basearch/debug
failovermethod=priority
priority=98
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG

</pre>


4) If you will be performing *local* batch system submission (as opposed to remote submission
via grid interfaces) you must confirm that whatever account you'll be submitting as exists on
the batch cluster. This is also the user you should set !AutoPyFactory to run as. 

*NOTE*: You do not want local batch logs being written to NFS, so you will need to define a 
local directory for logs and be sure the APF user can write there. 





5) Install the !AutoPyFactory RPMs:

!AutoPyFactory is now distributed as a set of RPMs, rather than a single one. 
The complete list of available RPMs is described in the following table:

<table class="tg">
  <tr>
    <th class="tg-header">RPM</th>
    <th class="tg-header">content</th>
    <th class="tg-header">dependencies</th>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-common</td>
    <td class="tg-031e"> All core files and directories needed to make !AutoPyFactory work </td>
    <td class="tg-031e"> autopyfactory-proxymanager <br> condor <br> python-simplejson <br> python-pycurl </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-proxymanager</td>
    <td class="tg-031e"> The files to install the proxy management tool, standalone </td>
    <td class="tg-031e"> voms-clients <br> myproxy </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-plugins-panda</td>
    <td class="tg-031e"> The files needed to allow !AutoPyFactory to interact with !PanDA </td>
    <td class="tg-031e"> </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-plugins-local</td>
    <td class="tg-031e"> The files needed to allow !AutoPyFactory to submit locally or to query a local condor pool </td>
    <td class="tg-031e"> </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-plugins-remote</td>
    <td class="tg-031e"> All files needed by !AutoPyFactory to submit pilots to the grid </td>
    <td class="tg-031e"> </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-plugins-cloud</td>
    <td class="tg-031e"> All files needed by !AutoPyFactory to submit pilots to the cloud </td>
    <td class="tg-031e"> </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-plugins-scheds</td>
    <td class="tg-031e"> The complete set of scheduler plugins </td>
    <td class="tg-031e"> </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-plugins-monitor</td>
    <td class="tg-031e"> The complete set of monitor plugins </td>
    <td class="tg-031e"> </td>
  </tr>

</table>


You can select the set of RPMs needed according to the particular purpose of your factory (submitting to a cloud, to the grid based on idle jobs in a local condor pool, etc.)
In all cases installing autopyfactory-common is required, as it contains the core functionalities of !AutoPyFactory.
<pre class="rootscreen">
%UCL_PROMPT_ROOT% yum install autopyfactory-common</pre>
   
This performs several setup steps that otherwise would need to be done manually:

   * Creates 'autopyfactory' user that !AutoPyFactory will run under by default.
   * Enables the factory init script via chkconfig.
   * Installs condor.
   * Installs python-simplejson and python-pycurl.
   * Installs RPM autopyfactory-proxymanager.


In order to facilitate the installation process, a set of META-RPMs are also available for the more common use cases:

<table class="tg">
  <tr>
    <th class="tg-header">META RPM</th>
    <th class="tg-header">Installs</th>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-remote</td>
    <td class="tg-031e"> autopyfactory-common <br> autopyfactory-plugins-remote </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-panda</td>
    <td class="tg-031e"> autopyfactory-common <br> autopyfactory-plugins-panda  </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-wms</td>
    <td class="tg-031e"> autopyfactory-common <br> autopyfactory-plugins-local </td>
  </tr>
<tr>
    <td class="tg-raw1">autopyfactory-cloud</td>
    <td class="tg-031e"> autopyfactory-common <br> autopyfactory-plugins-cloud </td>
  </tr>
</table>


6) Start !AutoPyFactory:

<pre class="rootscreen">
%UCL_PROMPT_ROOT% /etc/init.d/autopyfactory start</pre>
    
7) Confirm that everything is OK:

   *  Check to see if APF is running:
<pre class="rootscreen">
%UCL_PROMPT_ROOT% /etc/init.d/factory status</pre>

   * Look at the output of ps to see that !AutoPyFactory is running under the expected user. 
     This should show who it is running as, and the arguments in 
     =/etc/sysconfig/factory=: 

<pre class="rootscreen">
%UCL_PROMPT_ROOT% ps aux | grep autofactory | grep -v grep
502       6624  0.1  0.0 721440 12392 pts/0    Sl   Oct20   2:04 /usr/bin/python /usr/bin/autopyfactory --conf /etc/autopyfactory/autopyfactory.conf --info --sleep=60 --runas=autopyfactory --log=/var/log/autopyfactory/autopyfactory.log
</pre>

   *  Tail the log output and look for problems.

 <pre class="rootscreen">
%UCL_PROMPT_ROOT% tail -f /var/log/autopyfactory/autopyfactory.log</pre>
 
   * Check to be sure jobs are being submitted by whatever account !AutoPyFactory is using by executing condor_q manually:  

 <pre class="rootscreen">
%UCL_PROMPT_ROOT% condor_q | grep autopyfactory</pre>


---# Configuration

---## Format of the configuration files

The format of the configuration files is similar to the Microsoft INI files. The configuration file consists of sections, led by a =[section]= header and followed by =name: value= entries, with continuations in the style of [[http://tools.ietf.org/html/rfc822.html][RFC 822]] (see section 3.1.1, �LONG HEADER FIELDS�); =name=value= is also accepted. Note that leading whitespace is removed from values. Additional defaults can be provided on initialization and retrieval. Lines beginning with '#' or ';' are ignored and may be used to provide comments.

It accepts interpolation. This means values can contain format strings which refer to other values in the same section, or values in a special =[DEFAULT]= section.

Configuration files may include comments, prefixed by specific characters (# and ;). Comments may appear on their own in an otherwise empty line, or may be entered in lines holding values or section names. In the latter case, they need to be preceded by a whitespace character to be recognized as a comment. (For backwards compatibility, only ; starts an inline comment, while # does not.)

As the python package !ConfigParser is being used to digest the configuration files, a wider explanation and examples can be found in the [[https://docs.python.org/2/library/configparser.html][python documentation page]]. 

---## sysconfig/autopyfactory

The first set of configuration for the factory is done via the =/etc/sysconfig/autopyfactory= config file. 
This is the configuration file used by the daemon service to decide how to run the factory. 
It set the following variables:
   * log level: *WARNING*, *INFO* or *DEBUG*
   * time to sleep between internal cycles
   * the username to switch into to. Note the factory will not run as root, but as a non priviledged account
   * the log file
Also, any other modifications to the environment needed by the factory can be set in this file.
Example

<pre class="file">
OPTIONS="--debug --sleep=60 --runas=autopyfactory --log=/var/log/autopyfactory/autopyfactory.log"
CONSOLE_LOG=/var/log/autopyfactory/console.log
env | sort >> $CONSOLE_LOG
</pre>

---## autopyfactory.conf
<!--
*FIXME: check which variables are really mandatory and which ones are optional*

*FIXME: fix the format on the multiline cells*

*FIXME: fix the fake wiki words*
-->

<table class="tg">
  <tr>
    <th class="tg-header">variable</th>
    <th class="tg-header">description</th>
  </tr>

<tr>
    <td class="tg-raw1">baseLogDir</td>
    <td class="tg-031e"> where outputs from pilots are stored NOTE: No trailing '/'!!! </td>
  </tr>
<tr>
    <td class="tg-raw1">baseLogDirUrl</td>
    <td class="tg-031e">where outputs from pilots are available via http.  NOTE: It must include the port.  NOTE: No trailing '/'!!! </td>
  </tr>
<tr>
    <td class="tg-raw1">batchstatus.condor.sleep</td>
    <td class="tg-031e">time the Condor !BatchStatus Plugin waits between cycles Value is in seconds. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchstatus.maxtime</td>
    <td class="tg-031e">maximum time while the info is considered reasonable.  If info stored is older than that, is considered not valid, and some NULL output will be returned. </td>
  </tr>
<tr>
    <td class="tg-raw1">cycles</td>
    <td class="tg-031e">maximum number of times the queues will loop.  None means forever. </td>
  </tr>
<tr>
    <td class="tg-raw1">cleanlogs.keepdays</td>
    <td class="tg-031e">maximum number of days the condor logs will be kept, in case they are placed in a subdirectory for an APFQueue that is not being currently managed by !AutoPyFactory.  For example, an apfqueue that has been created and used for a short amount of time, and it does not exist anymore.  Still the created logs have to be cleaned at some point... </td>
  </tr>
<tr>
    <td class="tg-raw1">enablequeues</td>
    <td class="tg-031e">default value to enable/disable all queues at once.  When True, its value will be overriden by the queue config variable 'enabled', queue by queue.  When False, all queues will stop working, but the factory will still be alive performing basic actions (eg. printing logs). </td>
  </tr>
<tr>
    <td class="tg-raw1">factoryId</td>
    <td class="tg-031e">Name that the factory instance will have in the APF web monitor.  Make factoryId something descriptive and unique for your factory, for example <site>-<host>-<admin> (e.g. BNL-gridui11-jhover) </td>
  </tr>
<tr>
    <td class="tg-raw1">factoryAdminEmail</td>
    <td class="tg-031e">Email of the local admin to contact in case of a problem with an specific APF instance. </td>
  </tr>
<tr>
    <td class="tg-raw1">factorySMTPServer</td>
    <td class="tg-031e">Server to use to send alert emails to admin.  </td>
  </tr>
<tr>
    <td class="tg-raw1">factory.sleep</td>
    <td class="tg-031e">sleep time between cycles in mainLoop in Factory object Value is in seconds. </td>
  </tr>
<tr>
    <td class="tg-raw1">factoryUser</td>
    <td class="tg-031e">account under which APF will run </td>
  </tr>
<tr>
    <td class="tg-raw1">maxperfactory.maximum</td>
    <td class="tg-031e">maximum number of condor jobs to be running at the same time per Factory.  It is a global number, used by all APFQueues submitting pilots with condor.  The value will be used by !MaxPerFactorySchedPlugin plugin </td>
  </tr>
<tr>
    <td class="tg-raw1">logserver.enabled</td>
    <td class="tg-031e">determines if batch logs are exported via HTTP.  Valid values are True&verbar;False </td>
  </tr>
<tr>
    <td class="tg-raw1">logserver.index</td>
    <td class="tg-031e">determines if automatic directory indexing is allowed when log directories are browsed.  Valid values are True&verbar;False </td>
  </tr>
<tr>
    <td class="tg-raw1">logserver.allowrobots</td>
    <td class="tg-031e">if false, creates a robots.txt file in the docroot.  Valid valudes are True&verbar;False </td>
  </tr>
<tr>
    <td class="tg-raw1">proxyConf</td>
    <td class="tg-031e">local path to the configuration file for automatic proxy management.  NOTE: must be a local path, not a URI.  </td>
  </tr>
<tr>
    <td class="tg-raw1">proxymanager.enabled</td>
    <td class="tg-031e">to determine if automatic proxy management is used or not.  Accepted values are True&verbar;False </td>
  </tr>
<tr>
    <td class="tg-raw1">proxymanager.sleep</td>
    <td class="tg-031e"> Sleep interval for proxymanager thread.  </td>
  </tr>
<tr>
    <td class="tg-raw1">queueConf</td>
    <td class="tg-031e">URI plus path to the configuration file for APF queues.  NOTE: Must be expressed as a URI (file:// or http://) Cannot be used at the same time that queueDirConf </td>
  </tr>
<tr>
    <td class="tg-raw1">queueDirConf</td>
    <td class="tg-031e">directory with a set of configuration files, all of them to be used at the same time.  i.e.  /etc/autopyfactory/queues.d/ Cannot be used at the same time that queueConf </td>
  </tr>
<tr>
    <td class="tg-raw1">monitorConf</td>
    <td class="tg-031e">local path to the configuration file for Monitor plugins. </td>
  </tr>
<tr>
    <td class="tg-raw1">mappingsConf</td>
    <td class="tg-031e">local path to the configuration file with the mappings: for example, globus2info, jobstatus2info, etc. </td>
  </tr>
<tr>
    <td class="tg-raw1">wmsstatus.maximum</td>
    <td class="tg-031e">maximum time while the info is considered reasonable.  If info stored is older than that, is considered not valid, and some NULL output will be returned. </td>
  </tr>
<tr>
    <td class="tg-raw1">wmsstatus.panda.sleep</td>
    <td class="tg-031e">time the WMSStatus Plugin waits between cycles Value is in seconds. </td>
  </tr>
</table>


---## queues.conf

<!--
*FIXME: check which variables are really mandatory and which ones are optional*

*FIXME: fix the format on the multiline cells*

*FIXME: fix the fake wiki words*
-->

---### generic variables

<table class="tg">
  <tr>
    <th class="tg-header">variable</th>
    <th class="tg-header">description</th>
  </tr>

<!-- DEPRECATED
<tr>
    <td class="tg-raw1">cloud</td>
    <td class="tg-031e"> is the cloud this queue is in. You should set this to suppress pilot submission when the cloud goes offline N.B. Panda clouds are UPPER CASE, e.g., UK </td>
  </tr>
<tr>
    <td class="tg-raw1">vo</td>
    <td class="tg-031e"> Virtual Organization </td>
  </tr>
<tr>
    <td class="tg-raw1">grid</td>
    <td class="tg-031e"> Grid middleware flavor at the site. (e.g. OSG, EGI, !NorduGrid)  </td>
  </tr>
-->

<tr>
    <td class="tg-raw1">batchqueue</td>
    <td class="tg-031e"> the Batch system related queue name.  E.g. the !PanDA queue name (formerly called nickname) </td>
  </tr>
<tr>
    <td class="tg-raw1">wmsqueue</td>
    <td class="tg-031e"> the WMS system queue name.  E.g. the !PanDA siteid name </td>
  </tr>
<tr>
    <td class="tg-raw1">enabled</td>
    <td class="tg-031e"> determines if each queue section must be used by !AutoPyFactory or not. Allows to disable a queue without commenting out all the values.  Valid values are True&verbar;False. </td>
  </tr>
<tr>
    <td class="tg-raw1">status</td>
    <td class="tg-031e"> can be "test", "offline" or "online" </td>
  </tr>
<tr>
    <td class="tg-raw1">apfqueue.sleep</td>
    <td class="tg-031e"> sleep time between cycles in APFQueue object.  Value is in seconds.    </td>
  </tr>
<tr>
    <td class="tg-raw1">cleanlogs.keepdays</td>
    <td class="tg-031e"> maximum number of days the condor logs will be kept </td>
  </tr>
<tr>
    <td class="tg-raw1">monitorsection</td>
    <td class="tg-031e"> section in monitor.conf where info about the actual monitor plugin can be found.  The value can be a single section or a split by comma list of sections.  Monitor plugins handle job info publishing to one or more web monitor/dashboards.  </td>
  </tr>
<tr>
    <td class="tg-raw1">executable</td>
    <td class="tg-031e"> path to the script which will be executed.  As the purpose of the factory is to submit jobs to the different resources (local batch queues, grid sites, etc.) an executable, with its corresponding list of input arguments, is needed.  This executable can be anything.  Details on how to install the executable and the list of arguments are out of the scope of this documentation, though.</td>
  </tr>
<tr>
    <td class="tg-raw1">executable.arguments</td>
    <td class="tg-031e"> input options to be passed verbatim to the executable script. </td>
  </tr>
</table>


---### WMS Status Plugin variables

<table class="tg">
  <tr>
    <th class="tg-header">variable</th>
    <th class="tg-header">description</th>
  </tr>

<tr>
    <td class="tg-raw1">wmsstatusplugin</td>
    <td class="tg-031e"> WMS Status Plugin. </td>
  </tr>
<tr>
    <td class="tg-raw1">wmsstatus.condor.queryargs</td>
    <td class="tg-031e"> list of command line input options to be included in the query command *verbatim*. E.g.  wmsstatus.condorqueryargs = -name <schedd_name> ...  </td>
  </tr>
</table>

---### Batch Status Plugin variables

<table class="tg">
  <tr>
    <th class="tg-header">variable</th>
    <th class="tg-header">description</th>
  </tr>

<tr>
    <td class="tg-raw1">batchstatusplugin</td>
    <td class="tg-031e"> Batch Status Plugin. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchstatus.condor.queryargs</td>
    <td class="tg-031e"> list of command line input options to be included in the query command *verbatim*. E.g.  batchstatus.condor.queryargs = -name <schedd_name> -pool <centralmanagerhostname[:portnumber]> </td>
  </tr>
</table>

---### Sched Plugin variables

<table class="tg">
  <tr>
    <th class="tg-header">variable</th>
    <th class="tg-header">description</th>
  </tr>

<tr>
    <td class="tg-raw1">schedplugin</td>
    <td class="tg-031e"> specific Scheduler Plugin implementing the algorithm deciding how many new pilots to submit next cycle.  The value can be a single Plugin or a split by comma list of Plugins.  In the case of more than one plugin, each one will acts as a filter with respect to the value returned by the previous one.  By selecting the right combination of Plugins in a given order, a complex algorithm can be built. <BR> E.g., the algorithm can start by using Ready Plugin, which will determine the number of pilots based on the number of activated jobs in the WMS queue and the number of already submitted pilots.  After that, this number can be filtered to a maximum (!MaxPerCycleSchedPlugin) or a minimum (!MinPerCycleSchedPlugin) number of pilots.  Or even can be filtered to a maximum number of pilots per factory (!MaxPerFactorySchedPlugin) Also it can be filtered depending on the status of the wmsqueue (!StatusTestSchedPlugin, !StatusOfflineSchedPlugin). </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is Ready</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.ready.offset</td>
    <td class="tg-031e"> the minimum value in the number of ready jobs to trigger submission. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is Fixed</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.fixed.pilotspercycle</td>
    <td class="tg-031e"> fixed number of pilots to be submitted each cycle, when using the Fixed Scheduler Plugin. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is !MaxPerCycle</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.maxpercycle.maximum</td>
    <td class="tg-031e"> maximum number of pilots to be submitted per cycle </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is !MinPerCycle</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.minpercycle.minimum</td>
    <td class="tg-031e"> minimum number of pilots to be submitted per cycle </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is !MaxPending</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.maxpending.maximum</td>
    <td class="tg-031e"> maximum number of pilots to be pending </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is !MinPending</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.minpending.minimum</td>
    <td class="tg-031e"> minimum number of pilots to be pending </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is !MaxToRun</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.maxtorun.maximum</td>
    <td class="tg-031e"> maximum number of pilots allowed to, potentially, be running at a time.  </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is !StatusTest</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.statustest.pilots</td>
    <td class="tg-031e"> number of pilots to submit when the wmsqueue is in status = test </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is !StatusOffline</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.statusoffline.pilots</td>
    <td class="tg-031e"> number of pilots to submit when the wmsqueue or the cloud is in status = offline </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is Simple</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.simple.default</td>
    <td class="tg-031e"> default number of pilots to be submitted when the context information does not exist or is not reliable.  To be used in Simple Scheduler Plugin. </td>
  </tr>
<tr>
    <td class="tg-raw1">sched.simple.maxpendingpilots</td>
    <td class="tg-031e"> maximum number of pilots to be idle on queue waiting to start execution.  To be used in Simple Scheduler Plugin. </td>
  </tr>
<tr>
    <td class="tg-raw1">sched.simple.maxpilotspercycle</td>
    <td class="tg-031e"> maximum number of pilots to be submitted per cycle.  To be used in Simple Scheduler Plugin. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is Trivial</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.trivial.default</td>
    <td class="tg-031e"> default number of pilots to be submitted when the context information does not exist or is not reliable.  To be used in Trivial Scheduler Plugin. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is Scale</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.scale.factor</td>
    <td class="tg-031e"> scale factor to correct the previous value of the number of pilots.  Value is a float number. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when schedplugin is !KeepNRunning</td>
  </tr>
<tr>
    <td class="tg-raw1">sched.keepnrunning.keep_running</td>
    <td class="tg-031e"> number of total jobs to keep running and/or pending </td>
  </tr>
</table>

---### Batch Submit Plugin variables

<table class="tg">
  <tr>
    <th class="tg-header">variable</th>
    <th class="tg-header">description</th>
  </tr>

<tr>
    <td class="tg-raw1">batchsubmitplugin</td>
    <td class="tg-031e"> Batch Submit Plugin.  Currently available options are: !CondorGT2, !CondorGT5, !CondorCREAM, !CondorLocal, !CondorLSF, !CondorEC2, !CondorDeltaCloud. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when batchsubmitplugin is condorgt2</td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt2.gridresource</td>
    <td class="tg-031e"> name of the CE (e.g. gridtest01.racf.bnl.gov/jobmanager-condor) </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt2.submitargs</td>
    <td class="tg-031e"> list of command line input options to be included in the submission command *verbatim* e.g.  batchsubmit.condorgt2.submitargs = -remote my_schedd will drive into a command like condor_submit -remote my_schedd submit.jdl </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt2.condor_attributes</td>
    <td class="tg-031e"> list of condor attributes, splited by comma, to be included in the condor submit file *verbatim* <BR>e.g. +Experiment = "ATLAS",+VO = "usatlas",+Job_Type = "cas" Can be used to include any line in the Condor-G file that is not otherwise added programmatically by !AutoPyFactory.  Note the following directives are added by default: <BR>transfer_executable=True <BR>stream_output=False <BR>stream_error=False <BR>notification=Error <BR>copy_to_spool=false </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt2.environ</td>
    <td class="tg-031e"> list of environment variables, splitted by white spaces, to be included in the condor attribute environment *verbatim* Therefore, the format should be env1=var1 env2=var2 envN=varN split by whitespaces. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt2.proxy</td>
    <td class="tg-031e"> name of the proxy handler in proxymanager for automatic proxy renewal (See etc/proxy.conf) None if no automatic proxy renewal is desired. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">GlobusRSL GRAM2 variables</td>
  </tr>
<tr>
    <td class="tg-raw1">gram2</td>
    <td class="tg-031e"> The following are GRAM2 RSL variables.  They are just used to build batchsubmit.condorgt2.globusrsl (if needed) The globusrsl directive in the condor submission file looks like globusrsl=(jobtype=single)(queue=short) Documentation can be found here: http://www.globus.org/toolkit/docs/2.4/gram/gram_rsl_parameters.html </td>
  </tr>
<tr>
    <td class="tg-raw1">globusrsl.gram2.&#60;argument&#62;</td>
    <td class="tg-031e"> globusrsl.gram2.count <BR> globusrsl.gram2.directory <BR> globusrsl.gram2.dryRun <BR> globusrsl.gram2.environment <BR> globusrsl.gram2.executable <BR> globusrsl.gram2.gramMyJob <BR> globusrsl.gram2.hostCount <BR> globusrsl.gram2.jobType <BR> globusrsl.gram2.maxCpuTime <BR> globusrsl.gram2.maxMemory <BR> globusrsl.gram2.maxTime <BR> globusrsl.gram2.maxWallTime <BR> globusrsl.gram2.minMemory <BR> globusrsl.gram2.project <BR> globusrsl.gram2.queue <BR> globusrsl.gram2.remote_io_url <BR> globusrsl.gram2.restart <BR> globusrsl.gram2.save_state <BR> globusrsl.gram2.stderr <BR> globusrsl.gram2.stderr_position <BR> globusrsl.gram2.stdin <BR> globusrsl.gram2.stdout <BR> globusrsl.gram2.stdout_position <BR> globusrsl.gram2.two_phase </td>
  </tr>
<tr>
    <td class="tg-raw1">globusrsl.gram2.globusrsl</td>
    <td class="tg-031e"> GRAM RSL directive.  If this variable is not setup, then it will be built programmatically from all non empty globusrsl.gram2.XYZ variables.  If this variable is setup, then its value will be taken *verbatim*, and all possible values for globusrsl.gram2.XYZ variables will be ignored.  </td>
  </tr>
<tr>
    <td class="tg-raw1">globusrsl.gram2.globusrsladd</td>
    <td class="tg-031e"> custom fields to be added *verbatim* to the GRAM RSL directive, after it has been built either from globusrsl.gram2.globusrsl value or from all globusrsl.gram2.XYZ variables.  e.g. (condorsubmit=('+AccountingGroup' '\"group_atlastest.usatlas1\"')('+Requirements' 'True')) </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when batchsubmitplugin is condorgt5</td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt5.gridresource</td>
    <td class="tg-031e"> name of the CE (e.g. gridtest01.racf.bnl.gov/jobmanager-condor) </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt5.submitargs</td>
    <td class="tg-031e"> list of command line input options to be included in the submission command *verbatim* e.g.  batchsubmit.condorgt2.submitargs = -remote my_schedd will drive into a command like condor_submit -remote my_schedd submit.jdl </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt5.condor_attributes</td>
    <td class="tg-031e"> list of condor attributes, splited by comma, to be included in the condor submit file *verbatim* e.g. +Experiment = "ATLAS",+VO = "usatlas",+Job_Type = "cas" Can be used to include any line in the Condor-G file that is not otherwise added programmatically by !AutoPyFactory.  Note the following directives are added by default: <BR>transfer_executable=True <BR>stream_output=False <BR>stream_error=False <BR>notification=Error <BR>copy_to_spool=false </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt5.environ</td>
    <td class="tg-031e"> list of environment variables, splitted by white spaces, to be included in the condor attribute environment *verbatim* Therefore, the format should be env1=var1 env2=var2 envN=varN split by whitespaces. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorgt5.proxy</td>
    <td class="tg-031e"> name of the proxy handler in proxymanager for automatic proxy renewal (See etc/proxy.conf) None if no automatic proxy renewal is desired. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">GlobusRSL GRAM5 variables</td>
  </tr>
<tr>
    <td class="tg-raw1">gram5</td>
    <td class="tg-031e"> The following are GRAM5 RSL variables.  They are just used to build batchsubmit.condorgt5.globusrsl (if needed) The globusrsl directive in the condor submission file looks like globusrsl=(jobtype=single)(queue=short) Documentation can be found here: http://www.globus.org/toolkit/docs/5.2/5.2.0/gram5/user/#gram5-user-rsl  </td>
  </tr>
<tr>
    <td class="tg-raw1">globusrsl.gram5.&#60;argument&#62;</td>
    <td class="tg-031e"> globusrsl.gram5.count <BR> globusrsl.gram5.directory <BR> globusrsl.gram5.dry_run <BR> globusrsl.gram5.environment <BR> globusrsl.gram5.executable <BR> globusrsl.gram5.file_clean_up <BR> globusrsl.gram5.file_stage_in <BR> globusrsl.gram5.file_stage_in_shared <BR> globusrsl.gram5.file_stage_out <BR> globusrsl.gram5.gass_cache <BR> globusrsl.gram5.gram_my_job <BR> globusrsl.gram5.host_count <BR> globusrsl.gram5.job_type <BR> globusrsl.gram5.library_path <BR> globusrsl.gram5.loglevel <BR> globusrsl.gram5.logpattern <BR> globusrsl.gram5.max_cpu_time <BR> globusrsl.gram5.max_memory <BR> globusrsl.gram5.max_time <BR> globusrsl.gram5.max_wall_time <BR> globusrsl.gram5.min_memory <BR> globusrsl.gram5.project <BR> globusrsl.gram5.proxy_timeout <BR> globusrsl.gram5.queue <BR> globusrsl.gram5.remote_io_url <BR> globusrsl.gram5.restart <BR> globusrsl.gram5.rsl_substitution <BR> globusrsl.gram5.savejobdescription <BR> globusrsl.gram5.save_state <BR> globusrsl.gram5.scratch_dir <BR> globusrsl.gram5.stderr <BR> globusrsl.gram5.stderr_position <BR> globusrsl.gram5.stdin <BR> globusrsl.gram5.stdout <BR> globusrsl.gram5.stdout_position <BR> globusrsl.gram5.two_phase <BR> globusrsl.gram5.username </td>
  </tr>
<tr>
    <td class="tg-raw1">globusrsl.gram5.globusrsl</td>
    <td class="tg-031e"> GRAM RSL directive.  If this variable is not setup, then it will be built programmatically from all non empty globusrsl.gram5.XYZ variables.  If this variable is setup, then its value will be taken *verbatim*, and all possible values for globusrsl.gram5.XYZ variables will be ignored.  </td>
  </tr>
<tr>
    <td class="tg-raw1">globusrsl.gram5.globusrsladd</td>
    <td class="tg-031e"> custom fields to be added *verbatim* to the GRAM RSL directive, after it has been built either from globusrsl.gram5.globusrsl value or from all globusrsl.gram5.XYZ variables.  e.g. (condorsubmit=('+AccountingGroup' '\"group_atlastest.usatlas1\"')('+Requirements' 'True')) </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when batchsubmitplugin is condorcream</td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorcream.webservice</td>
    <td class="tg-031e"> web service address (e.g. ce04.esc.qmul.ac.uk:8443/ce-cream/services/CREAM2) </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorcream.submitargs</td>
    <td class="tg-031e"> list of command line input options to be included in the submission command *verbatim* e.g.  batchsubmit.condorgt2.submitargs = -remote my_schedd will drive into a command like condor_submit -remote my_schedd submit.jdl </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorcream.condor_attributes</td>
    <td class="tg-031e"> list of condor attributes, splited by comma, to be included in the condor submit file *verbatim* e.g. +Experiment = "ATLAS",+VO = "usatlas",+Job_Type = "cas" Can be used to include any line in the Condor-G file that is not otherwise added programmatically by !AutoPyFactory.  Note the following directives are added by default: <BR>transfer_executable=True <BR>stream_output=False <BR>stream_error=False <BR>notification=Error <BR>copy_to_spool=false </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorcream.environ</td>
    <td class="tg-031e"> list of environment variables, splitted by white spaces, to be included in the condor attribute environment *verbatim* Therefore, the format should be env1=var1 env2=var2 envN=varN split by whitespaces. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorcream.queue</td>
    <td class="tg-031e"> queue within the local batch system (e.g. short) </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorcream.port</td>
    <td class="tg-031e"> port number. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorcream.batch</td>
    <td class="tg-031e"> local batch system (pbs, sge...) </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorcream.gridresource</td>
    <td class="tg-031e"> grid resource, built from other vars using interpolation: batchsubmit.condorcream.gridresource = %(batchsubmit.condorcream.webservice)s:%(batchsubmit.condorcream.port)s/ce-cream/services/CREAM2 %(batchsubmit.condorcream.batch)s %(batchsubmit.condorcream.queue)s </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorcream.proxy</td>
    <td class="tg-031e"> name of the proxy handler in proxymanager for automatic proxy renewal (See etc/proxy.conf) None if no automatic proxy renewal is desired. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when batchsubmitplugin is condorosgce</td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorosgce.remote_condor_schedd</td>
    <td class="tg-031e"> condor schedd  </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorosgce.remote_condor_collector</td>
    <td class="tg-031e"> condor collector </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorosgce.gridresource</td>
    <td class="tg-031e"> to be used in case schedd and collector are the same </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorosgce.proxy</td>
    <td class="tg-031e"> name of the proxy handler in proxymanager for automatic proxy renewal (See etc/proxy.conf) None if no automatic proxy renewal is desired. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorosgce.condor_attributes</td>
    <td class="tg-031e"> list of condor attributes, splited by comma, to be included in the condor submit file *verbatim* </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when batchsubmitplugin is condorec2</td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.gridresource</td>
    <td class="tg-031e"> ec2 service's URL (e.g. https://ec2.amazonaws.com/ ) </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.submitargs</td>
    <td class="tg-031e"> list of command line input options to be included in the submission command *verbatim* e.g.  batchsubmit.condorgt2.submitargs = -remote my_schedd will drive into a command like condor_submit -remote my_schedd submit.jdl </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.condor_attributes</td>
    <td class="tg-031e"> list of condor attributes, splited by comma, to be included in the condor submit file *verbatim* </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.environ</td>
    <td class="tg-031e"> list of environment variables, splitted by white spaces, to be included in the condor attribute environment *verbatim* Therefore, the format should be env1=var1 env2=var2 envN=varN split by whitespaces. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.ami_id</td>
    <td class="tg-031e"> identifier for the VM image, previously registered in one of Amazon's storage service (S3 or EBS) </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.ec2_spot_price</td>
    <td class="tg-031e"> max price to pay, in dollars to three decimal places. e.g. .040 </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.instance_type</td>
    <td class="tg-031e"> hardware configurations for instances to run on, .e.g m1.medium </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.user_data</td>
    <td class="tg-031e"> up to 16Kbytes of contextualization data.  This makes it easy for many instances to share the same VM image, but perform different work. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.access_key_id</td>
    <td class="tg-031e"> path to file with the EC2 Access Key ID </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.secret_access_key</td>
    <td class="tg-031e"> path to file with the EC2 Secret Access Key </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorec2.proxy</td>
    <td class="tg-031e"> name of the proxy handler in proxymanager for automatic proxy renewal (See etc/proxy.conf) None if no automatic proxy renewal is desired. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when batchsubmitplugin is condordeltacloud</td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.gridresource</td>
    <td class="tg-031e"> ec2 service's URL (e.g. https://deltacloud.foo.org/api ) </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.username</td>
    <td class="tg-031e"> credentials in !DeltaCloud </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.password_file</td>
    <td class="tg-031e"> path to the file with the password </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.image_id</td>
    <td class="tg-031e"> identifier for the VM image, previously registered with the cloud service. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.keyname</td>
    <td class="tg-031e"> in case of using SSH, the command keyname specifies the identifier of the SSH key pair to use.  </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.realm_id</td>
    <td class="tg-031e"> selects one between multiple locations the cloud service may have. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.hardware_profile</td>
    <td class="tg-031e"> selects one between the multiple hardware profiles the cloud service may provide </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.hardware_profile_memory</td>
    <td class="tg-031e"> customize the hardware profile </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.hardware_profile_cpu</td>
    <td class="tg-031e"> customize the hardware profile </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.hardware_profile_storage</td>
    <td class="tg-031e"> customize the hardware profile </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condordeltacloud.user_data</td>
    <td class="tg-031e"> contextualization data </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when batchsubmitplugin is condorlocal</td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorlocal.submitargs</td>
    <td class="tg-031e"> list of command line input options to be included in the submission command *verbatim* e.g.  batchsubmit.condorgt2.submitargs = -remote my_schedd will drive into a command like condor_submit -remote my_schedd submit.jdl </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorlocal.condor_attributes</td>
    <td class="tg-031e"> list of condor attributes, splited by comma, to be included in the condor submit file *verbatim* e.g. +Experiment = "ATLAS",+VO = "usatlas",+Job_Type = "cas" Can be used to include any line in the Condor-G file that is not otherwise added programmatically by !AutoPyFactory.  Note the following directives are added by default: <BR>universe = vanilla <BR>transfer_executable = True <BR>should_transfer_files = IF_NEEDED <BR>+TransferOutput = "" <BR>stream_output=False <BR>stream_error=False <BR>notification=Error <BR>periodic_remove = (!JobStatus == 5 && (!CurrentTime - !EnteredCurrentStatus) > 3600) &verbar;&verbar; (!JobStatus == 1 && globusstatus =!= 1 && (!CurrentTime - !EnteredCurrentStatus) > 86400) <BR>To be used in !CondorLocal Batch Submit Plugin. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorlocal.environ</td>
    <td class="tg-031e"> list of environment variables, splitted by white spaces, to be included in the condor attribute environment *verbatim* To be used by !CondorLocal Batch Submit Plugin.  Therefore, the format should be env1=var1 env2=var2 envN=varN split by whitespaces. </td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorlocal.proxy</td>
    <td class="tg-031e"> name of the proxy handler in proxymanager for automatic proxy renewal (See etc/proxy.conf) None if no automatic proxy renewal is desired. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when batchsubmitplugin is condorlsf</td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condorlsf.proxy</td>
    <td class="tg-031e"> name of the proxy handler in proxymanager for automatic proxy renewal (See etc/proxy.conf) None if no automatic proxy renewal is desired. </td>
  </tr>
<tr>
    <td colspan="2" class="tg-splitheader">Configuration when batchsubmitplugin is nordugrid</td>
  </tr>
<tr>
    <td class="tg-raw1">batchsubmit.condornordugrid.gridresource</td>
    <td class="tg-031e"> name of the ARC CE i.e. lcg-lrz-ce2.grid.lrz.de </td>
  </tr>
<tr>
    <td class="tg-raw1">nordugridrsl</td>
    <td class="tg-031e"> Entire RSL line.  i.e. (jobname = 'prod_pilot')(queue=lcg)(runtimeenvironment = APPS/HEP/ATLAS-SITE-LCG)(runtimeenvironment = ENV/PROXY ) (environment = ('APFFID' 'voatlas94') ('PANDA_JSID' 'voatlas94') ('GTAG' 'http://voatlas94.cern.ch/pilots/2012-11-19/LRZ-LMU_arc/$(Cluster).$(Process).out') ('RUCIO_ACCOUNT' 'pilot') ('APFCID' '$(Cluster).$(Process)') ('APFMON' 'http://apfmon.lancs.ac.uk/mon/') ('FACTORYQUEUE' 'LRZ-LMU_arc')  </td>
  </tr>
<tr>
    <td class="tg-raw1">nordugridrsladd</td>
    <td class="tg-031e"> A given tag to be added to the Nordugrid RSL line </td>
  </tr>
<tr>
    <td class="tg-raw1">nordugridrsl.addenv.<XYZ></td>
    <td class="tg-031e"> A given tag to be added within the 'environment' tag to the Nordugrid RSL line i.e. nordugridrsl.addenv.RUCIO_ACCOUNT = pilot will be added as ('RUCIO_ACCOUNT' 'pilot' ) </td>
  </tr>
</table>


<!--
 This variable can be built making use of an auxiliar variable called executable.defaultarguments This proposed ancilla works as a template, and its content is created on the fly from the value of other variables.  This mechanism is called "interpolation", docs can be found here: http://docs.python.org/library/configparser.html 
An example of this type of templates (included in the DEFAULTS block) is like this: executable.defaultarguments = --wrappergrid=%(grid)s \ --wrapperwmsqueue=%(wmsqueue)s \ --wrapperbatchqueue=%(batchqueue)s \ --wrappervo=%(vo)s \ --wrappertarballurl=http://dev.racf.bnl.gov/dist/wrapper/wrapper.tar.gz \ --wrapperserverurl=http://pandaserver.cern.ch:25080/cache/pilot \ --wrapperloglevel=debug executable.defaultarguments =  -s %(wmsqueue)s \ -h %(batchqueue)s -p 25443 \ -w https://pandaserver.cern.ch  -j false  -k 0  -u user |
-->

---## proxy.conf

<!--
*FIXME: check which variables are really mandatory and which ones are optional*

*FIXME: fix the format on the multiline cells*

*FIXME: fix the fake wiki words*
-->

<table class="tg">
  <tr>
    <th class="tg-header">variable</th>
    <th class="tg-header">description</th>
  </tr>
<tr>
    <td class="tg-raw1">baseproxy</td>
    <td class="tg-031e"> If used, create a very long-lived proxy, e.g. grid-proxy-init -valid 720:0 -out /tmp/plainProxy Note that maintenance of this proxy must occur completely outside of APF. </td>
  </tr>
<tr>
    <td class="tg-raw1">proxyfile</td>
    <td class="tg-031e"> Target proxy path.</td>
  </tr>
<tr>
    <td class="tg-raw1">lifetime</td>
    <td class="tg-031e"> Initial lifetime, in seconds (604800 = 7 days)</td>
  </tr>
<tr>
    <td class="tg-raw1">checktime</td>
    <td class="tg-031e"> How often to check proxy validity, in seconds</td>
  </tr>
<tr>
    <td class="tg-raw1">minlife</td>
    <td class="tg-031e"> Minimum lifetime of VOMS attributes for a proxy (renew if less) in seconds</td>
  </tr>
<tr>
    <td class="tg-raw1">interruptcheck</td>
    <td class="tg-031e"> Frequency to check for keyboard/signal interrupts, in seconds</td>
  </tr>
<tr>
    <td class="tg-raw1">renew</td>
    <td class="tg-031e"> If you do not want to use !ProxyManager to renew proxies, set this False and only define 'proxyfile' If renew is set to false, then no grid client setup is necessary. </td>
  </tr>
<tr>
    <td class="tg-raw1">usercert</td>
    <td class="tg-031e"> Path to the user grid certificate file</td>
  </tr>
<tr>
    <td class="tg-raw1">userkey</td>
    <td class="tg-031e"> Path to the user grid key file</td>
  </tr>
<tr>
    <td class="tg-raw1">vorole</td>
    <td class="tg-031e"> User VO role for target proxy. !MyProxy Retrieval Functionality: Assumes you have created a long-lived proxy in a !MyProxy server, out of band. </td>
  </tr>
<tr>
    <td class="tg-raw1">flavor</td>
    <td class="tg-031e"> voms or myproxy. voms directly generates proxy using cert or baseproxy myproxy retrieves a proxy from myproxy, then generates the target proxy against voms using it as baseproxy.</td>
  </tr>
<tr>
    <td class="tg-raw1">myproxy_hostname</td>
    <td class="tg-031e"> Myproxy server host. </td>
  </tr>
<tr>
    <td class="tg-raw1">myproxy_username</td>
    <td class="tg-031e"> User name to be used on !MyProxy service</td>
  </tr>
<tr>
    <td class="tg-raw1">myproxy_passphrase</td>
    <td class="tg-031e"> Passphrase for proxy retrieval from !MyProxy</td>
  </tr>
<tr>
    <td class="tg-raw1">retriever_profile</td>
    <td class="tg-031e"> A list of other proxymanager profiles to be used to authorize proxy retrieval from !MyProxy. </td>
  </tr>
<tr>
    <td class="tg-raw1">initdelay</td>
    <td class="tg-031e"> In seconds, how long to wait before generating. Needed for !MyProxy when using cert authentication--we need to allow time for the auth credential to be generated (by another proxymanager profile). </td>
  </tr>
<tr>
    <td class="tg-raw1">owner</td>
    <td class="tg-031e"> If running standalone (as root) and you want the proxy to be owned by another account. </td>
  </tr>
<tr>
    <td class="tg-raw1">Remote</td>
    <td class="tg-031e"> Proxy Maintenance: Assumes you have enabled ssh-agent key-based access to the remote host where you want to maintain a proxy file. </td>
  </tr>
<tr>
    <td class="tg-raw1">remote_host</td>
    <td class="tg-031e"> copy proxyfile to same path on remote host </td>
  </tr>
<tr>
    <td class="tg-raw1">remote_user</td>
    <td class="tg-031e"> User to connect as? </td>
  </tr>
<tr>
    <td class="tg-raw1">remote_owner</td>
    <td class="tg-031e"> If connect user is root, what account should own the file? </td>
  </tr>
<tr>
    <td class="tg-raw1">remote_group</td>
    <td class="tg-031e"> If connect user is root, what group should own the file? </td>
  </tr>
<tr>
    <td class="tg-raw1">voms.args</td>
    <td class="tg-031e"> Any extra arbitrary input option to be added to voms-proxy-init command</td>
  </tr>
</table>

---## monitor.conf

<!--
*FIXME: check which variables are really mandatory and which ones are optional*

*FIXME: fix the format on the multiline cells*

*FIXME: fix the fake wiki words*
-->


<table class="tg">
  <tr>
    <th class="tg-header">variable</th>
    <th class="tg-header">description</th>
  </tr>
<tr>
    <td class="tg-raw1">monitorplugin</td>
    <td class="tg-031e"> the type of plugin to handle this monitor instance </td>
  </tr>
<tr>
    <td class="tg-raw1">monitorURL</td>
    <td class="tg-031e"> URL for the web monitor </td>
  </tr>
</table>



---# Relase notes
---## Relase semantics

!AutoPyFactory release versions are composed by 4 numbers:
<pre>
        major.minor.release-build
</pre>
For example: 1.2.3-4

   * A change in the major number means the entire architecture of 
  !AutoPyFactory has been redesign. It implies a change at the conceptual
  level. In other words, changing the major number means a new project. 

   * A change in the configuration files that requires sys admins intervention
  after updating implies a change in the minor number.

   * Implementing a new relevant feature implies changing the minor number.

   * A significative amount of code refactoring that may affect the performance
  of !AutoPyFactory -including speed, memory usage, disk usage, etc-
  implies changing the minor number.

   * Small features and bug fixes imply changing the release number. 

   * A change in the RPM package but not in the code are reflected in the
  build number.

   * Not all new releases are placed in the production RPM repository. 
  Many of them are available at the development and testing repositories, 
  but only those that have been verified to work are moved 
  to the production repository. 

   * Same RPM will have always the same numbers in all repositories. 

---## version 2.4.0

Version 2.4.0 introduces major changes in name of files and directories, 
programs, users accounts, processes, etc. 
This recipe should help with a step by step migration:
        
 1. stop the factory

<pre class="rootscreen">
%UCL_PROMPT_ROOT% service factory stop
</pre>
  
 2. install RPM for autopyfactory-2.4.0
        
first, it is needed to removed the previous installation and the one for autopyfactory-tools, 
if it is installed, since there are incompatible requirements
This will delete some files and directories. If you customized the logrotation, you may want to make a copy first.
Also make a security copy of the configuration directory
 
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /etc/logrotate.d/autopyfactory.logrotate /tmp/
%UCL_PROMPT_ROOT% cp /etc/sysconfig/factory.sysconfig /tmp/
%UCL_PROMPT_ROOT% mkdir /tmp/etc/
%UCL_PROMPT_ROOT% cp /etc/apf/* /tmp/etc/
</pre>
       
Remove the old packages:
  
<pre class="rootscreen">
%UCL_PROMPT_ROOT% rpm -e panda-autopyfactory panda-autopyfactory-tools
</pre>        

Install the new autopyfactory package:

<pre class="rootscreen">
%UCL_PROMPT_ROOT% yum install autopyfactory
</pre>


3. Several directories have been created. 

Directory =/etc/autopyfactory/= has been created, but it is empty. 

The examples for the config files are placed under =/usr/share/doc/autopyfactory-2.4.0/=.
 
Also the examples for logrotate and sysconfig files are in  =/usr/share/doc/autopyfactory-2.4.0/logrotate/= and =/usr/share/doc/autopyfactory-2.4.0/sysconfig/=
        
The old config files are still under =/etc/apf/= and the old sysconfig is still as =/etc/sysconfig/factory.sysconfig=
        
4. sysconfig
        
Option 1: copy the new one

<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /usr/share/doc/autopyfactory-2.4.0/sysconfig/autopyfactory-example /etc/sysconfig/autopyfactory
</pre>
        
Option 2: copy the old one
   
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /tmp/factory.sysconfig  /etc/sysconfig/autopyfactory
</pre>
        
In the second case, some adjustments may be needed:
     
   *  replace      --runas=apf                           -->  --runas=autopyfactory
   *  replace      --log=/var/log/apf/apf.log            -->  --log=/var/log/autopyfactory/autopyfactory.log
   *  replace      CONSOLE_LOG=/var/log/apf/console.log  -->  CONSOLE_LOG=/var/log/autopyfactory/console.log       
 

5. log rotation
        
Option 1: copy the new one
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /usr/share/doc/autopyfactory-2.4.0/logrotate/autopyfactory-example /etc/logrotate.d/autopyfactory
</pre>

Option 2: copy the old one (saved in /tmp/)

<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /tmp/autopyfactory.logrotate /etc/logrotate.d/autopyfactory
</pre>
        
In the second case, some adjustments may be needed:
        
   * replace       /var/log/apf/apf.log         -->     /var/log/autopyfactory/autopyfactory.log
   * replace       /var/log/apf/console.log     -->     /var/log/autopyfactory/console.log
   * replace       /etc/init.d/factory          -->     /etc/init.d/autopyfactory
        
6. autopyfactory.conf
        
Option 1: copy the new one
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /usr/share/doc/autopyfactory-2.4.0/autopyfactory.conf-example  /etc/autopyfactory/autopyfactory.conf
</pre>
        
Option 2: copy the old one
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /tmp/etc/factory.conf /etc/autopyfactory/autopyfactory.conf
</pre>
        
In the second case, some adjustments may be needed:
        
   * replace        factoryUser = apf                           -->  factoryUser = autopyfactory
   * replace        queueConf = file:///etc/apf/queues.conf     -->  queueConf = file:///etc/autopyfactory/queues.conf
   * replace        queueDirConf = /etc/apf/queues.d/           -->  queueDirConf = /etc/autopyfactory/queues.d/
   * replace        proxyConf = /etc/apf/proxy.conf             -->  proxyConf = /etc/autopyfactory/proxy.conf
   * replace        monitorConf = file:///etc/apf/monitor.conf  -->  monitorConf = /etc/autopyfactory/monitor.conf
   * replace        baseLogDir = /home/apf/factory/logs         -->  baseLogDir = /home/autopyfactory/factory/logs
   * add line                        mappingsConf = /etc/autopyfactory/mappings.conf
        
7. queues.conf
        
Option 1: copy the new one

<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /usr/share/doc/autopyfactory-2.4.0/queues.conf-example  /etc/autopyfactory/queues.conf
</pre>        

Option 2: copy the old one
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /tmp/etc/queues.conf /etc/autopyfactory/queues.conf
</pre>
        
In the first case, the file needs to be configured from scratch.
In the second case, no adjustments is needed.
        
8. proxy.conf
        
Option 1: copy the new one
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /usr/share/doc/autopyfactory-2.4.0/proxy.conf-example  /etc/autopyfactory/proxy.conf
</pre>
        
Option 2: copy the old one
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /tmp/etc/proxy.conf /etc/autopyfactory/proxy.conf
</pre>
        
In the first case, the file needs to be configured from scratch.
In the second case, no adjustments is needed.
        
9. monitor.conf
        
Option 1: copy the new one
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /usr/share/doc/autopyfactory-2.4.0/monitor.conf-example  /etc/autopyfactory/monitor.conf
</pre>
        
Option 2: copy the old one
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /tmp/etc/monitor.conf /etc/autopyfactory/monitor.conf
</pre>
        
In the first case, the file needs to be configured from scratch, but most probably the default configuration is enough.
In the second case, no adjustments is needed.
        
10. mappings.conf
        
This config file is new, so it must be copied 
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% cp /usr/share/doc/autopyfactory-2.4.0/mappings.conf-example  /etc/autopyfactory/mappings.conf
</pre>        
        
Do not touch it.
        
11. since the factory will now run as user =autopyfactory= instead of =apf=, the new UNIX account needs to be created, if not already done during the RPM install process.
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% useradd autopyfactory
</pre>
        
assuming that account also hosts the keys for the X509 proxies in the regular directory .globus:

<pre class="rootscreen">
%UCL_PROMPT_ROOT% mkdir ~autopyfactory/.globus
%UCL_PROMPT_ROOT% cp -r ~apf/.globus/* ~autopyfactory/.globus/
%UCL_PROMPT_ROOT% chown -R autopyfactory:autopyfactory ~autopyfactory/.globus
</pre>
        
if that is not the case, then copy the .pem keys and/or change their ownership.
And to avoid problems, delete the current X509 that may still be in =/tmp/=
        
12. Install autopyfactory-tools
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% yum install autopyfactory-tools
</pre>        

13. start the factory
        
<pre class="rootscreen">
%UCL_PROMPT_ROOT% service autofactory start
</pre>
        
*WARNING*: after migrating to 2.4.0, factory runs under user =autopyfactory= instead of =apf=.
That means no one will now clean the old directories =/var/log/apf/= and =~apf/factory/logs/=
You may delete them at some point (not right away, since they will include condor logs for still running pilots)
        

---## upgrading a factory from 2.3.1 to 2.4.0

In order to upgrade a factory from old stable version 2.3.1 to latest 2.4.x series, a few things need to be taken into account.

   * The name of files, directories, and processes has changed. A detailed explanation is in the above section [[#5_2_version_2_4_0][version 2.4.0]]
   * a new optional variable has been included in the file =proxy.conf=: ==voms.args==
   * a new mandatory option has been added to the new file =autopyfactory.conf=: ==mappingsConf==


---## version 2.3.2

   * RPM built incorrectly. Rebuilt against correct copy of code.  

---## version 2.3.0

   * utils not distributed anymore within the RPM. They will be distributed with a dedicated one.
   * variable 'flavor' mandatory in DEFAULT section in =proxy.conf= Values are voms or myproxy
   * In case ==flavor=myproxy== in =proxy.conf=, then these variables are needed:
      * remote_host
      * remote_user
      * remote_owner
      * remote_group
   * New variable ==factorySMTPServer== in =factory.conf=
   * New variable ==proxymanager.sleep== in =factory.conf=

---## version 2.2.0-1

   * examples of executables (a.k.a. wrappers) 
are placed underneath the =/etc/apf/= directory.
They are not copied directly into =/usr/libexec/= anymore.
   * wrapper-0.9.9.sh has a different set of
  input options than previous one. 
  Read carefully the inline documentation before using it.
   * Config plugins have been removed. 
  Any configuration variable in =queues.conf=
  related !PandaConfig or AGISConfig plugins 
  are not valid anymore. 
  Therefore the variable ==configplugin== is gone too.
   * Variables ==override== and ==autofill== are also gone.
   * There is a new configuration file called =monitor.conf=
  An example is provided underneath =/etc/apf/=
   * Old variable in =factory.conf= pointing to the monitor URL
  is now in =monitor.conf=. The =monitor.conf= contains sections
  for different monitor configurations.
  The name of the section is setup in =queues.conf= via
  the new variable ==monitorsection==. Read carefully the inline documentation in =monitor.conf= before using it.
   * Utils, including script to generate =queues.conf=
  with information from AGIS, have changed name and location.
  New scripts are place underneath =/usr/share/apf=

---# CHANGELOG
<pre>
2.4.5 

* trying several paths to import panda Client.py

2.4.4

* each APFQueue carrying only one section in the config loader object qcl, instead of all sections, to avoid scalability issues.

2.4.3

* creating the directory baseLogDir if it does not exist yet (for example, first time APF is installed)
* removed manpages management from rpm-post.sh script

2.4.2

* variable batchqueue not mandatory
* typo fixed in proxymanager.py

2.4.1

* reorganizing the docs/* files, etc/* files,  and the man/* files
* added requirements from voms-clients and myproxy in setup.cfg
* removed the handling of sysconfig files in rpm-post.sh
* mappings.conf created.
  plugins now read the mappings from that config file, instead of having hardcoded dictionaries.
* explanation for "lifetime" and "minlife" fixed in proxy.conf-example, 
  and variable "vomshours" renamed as "hours" in proxymanager.
  doc updated.
  method _checkTimeleft() renamed  _checkVOMSTimeLeft(). Log messages fixed accordingly.
*  created method _checkProxyTimeLeft()
*  added a check on proxy timeleft shorter than voms timeleft
* Bugs and typos fixed
* changed nomenclature: everything now is called "autopyfactory" instead of "apf" or "factory"
  .sysconfig removed from  /etc/sysconfig/autopyfactory.sysconfig
  panda- removed from package name
  no wrappers copied to the /etc/ directory
* accept multiple XML docs as output of "condor_q -g". 
* checking if the output of condor_q in querycondor() is still XML even when RC != 0
* if -name and -pool are empty, the condor_q_id is again "local"
* checking output of condor_q() is not None in WMS Status plugin Condor
* removed WMS Status plugin CondorLocal (moved to attic)
* new grid_resource line in Condor-CE submit plugin: CondorOSGCE
* added voms.args to proxymanager.py
* condorlocal -> condor for WMS Status plugin in queues.conf-example and documentation
* adding Condor WMS Status plugin, which is a multi-singleton, to replace old  CondorLocal WMS Status plugin
* allow getwmsstatusplugin() to return a multi-singleton plugin object
* Using queryargs in WMS Status plugin CondorLocal
* Email sent when the generated X509 proxy is not valid: does not exist, too old, or not proper VOMS attributes
* Adding a log message in StatusTest and StatusOffline Sched Plugins 
  when the queue is not test or offline.
* reading self.cloud from queues.conf removed
  Variables not used anymore deleted from queues.conf-example
* bug in manpage autopyfactory.1 fixed
* created submit plugin CondorPBS
* removed reload() function from the init script

ChangeLog 2014-01-24

* Fixed Condor submit plugin initialization hierarchy. 
* Switched from os.getlogin() to pwd.

ChangeLog 2014-01-02
--------

* adjustments to init.d script to improve error codes/detection
* proxymanager.sleep and remote_* config vars added to -example files. 

ChangeLog 2013-12-03
---------

* sched plugin Activated deleted
* bug fixed in method fill() in info.py to prevent an Exception when the dictionary has an unknown key.
* CondorEC2 BatchSubmit and BatchStatus plugins usable, supporting standard Condor ec2 grid type. Assuming VMs join local pool as startds, features correlation of VM jobs and corresponding startd. VM retirement via 'condor_off -peaceful' and VM shutdown when stard is retired. 
* KeepNRunning sched plugin to convert absolute to relative numbers. 
* utils not distributed anymore within the RPM. They will be distributed with a dedicated one.
* Removed reference to Panda cloud status in StatusOfflineSchedPlugin
* created apf-simulated-scheds in misc/
* Proxymanager now able to be run standalone as standard system init daemon. This is so base certs need not be owned or readable by the APF user. 
* Added email notification of factory owner when no valid proxy can be retrieved from the proxymanager. 
* Eliminated all _readconfig() methods in submit plugins. Switched to full initialization during __init__.
* MyProxy support in proxymanager. Allows retrieval of base proxy from MyProxy using passphrase, or using another proxymanager profile proxy for auth.
* fixed bug in Scale sched plugin returning 0 when n*factor < 1. 
* minimum Condor version check. Allows particular plugins to specify minimum. Failure aborts. 
* multiproxy functionality. Allow multiple proxy profiles. proxymanager tries all until one is found. failure generates email.  
* scripts and config files added for logs monitor apf-search-failed
* strip() after split by comma in configloader, to allow things like 'x = foo, bar' with whitespace after comma
* bug in MaxPending sched plugin logic fixed. Now no limit imposed when there are no pending pilots.
* queues configuration files can be read from a directory (i.e. /etc/apf/queues.d/). configloader adapted to accept directories instead of list of URIs
* method name removed from log messages.
* fixed bug in some sched plugins, mixing None and 0 in the logic
* add documentation to install.html (in verbatim, no html format)
* removed all methods for FactoryCLI from bin/factory, and mainLoop() renamed to run()
* added new custom logging level -TRACE- and using it for some long messages, like the output of condor_q in XML format
* configloader converts None in conf to Python None object. Change in default_value logic--if no default_value is provided
  then generic_get returns None. 
* info major refactoring of Info class hierarchy. most objects now have overridden methods to avoid exception generation. 
* passing queryargs from queues.conf to query.querycondor() call at Condor batchstatus plugin.
* siteid removed from several places and replaced by wmsqueue.
* generic_get() simplified
* InfoContainer removed. 
* fake info classes imports removed, and importing from the right place (info.py instead of factory.py)
* log messages in sched plugins more homogeneous. Now all of them are "Return=123".
* created a script in misc/ to search for pilots running (in theory) for more than 8 days.
* Removed allowed variables for Test and Offline Sched plugins, and from the queues.conf. If the plugin is used, we assume it is allowed. 
* more robust code to deal with scenario where condor_q gives no output
* all JSD.add() method replaced to use the new format (2 inputs instead of 1)
* jsd.py and jsd3.py moved to attic/ and jsd4.py moved to jsd.py
* logserver2.py moved to logserver.py, and old one moved to attic/
* using method merge() instead of deepcopy() in configloader.py
* method section2dict() created in configloader. It will be usefull to generate the mappings from config files
* getConfig() method in configloader.py embedded in a try - except block
  and all config loader object creation in factory.py embedded in try - except blocks
* Exception class ConfigFailure renamed ConfigFailureMandatoryAttr
* Cleaning info.py code:
    -- method dict() removed
    -- method getconfig() removed
    -- method __add__() removed
    -- method set() removed
    -- method get() removed
    -- property total removed
    -- class attribute valid = [] removed from all classes:
        -- therefore method reset() removed
        -- therefore method __setattr__() removed
    -- method __getattribute__() is created
    -- method valid() in class InfoContainer deleted
    -- no longer importing Config from configloader 
    -- no longer self.default_value
    -- all __init__() methods now hardcode the entire list of attributes
* Removed logger from the input options in method generic_get()
* As temporary solution, NotImplementedAttr defined in configloader.py
* Documentation on old Sched Plugin SimpleNQueue deleted.
* First draft for manpages created, and rpm-post script adapted to install them.
* Printing env again after switching ID.
* Bug fixed in CREAM example in queues.conf-example
* created misc/apf-panda-jobs-info.py 
* INFO messages in configloader for missing non-mandatory variables moved to DEBUG.
* all __XYZ__ module names deleted, except in factory.py
* Fixed setup.cfg
* Adjusted sysconfig, factory init, and logrotate to use a console.log for python interpreter-level 
  debugging. 
* Added a log message with the APF version number.
* All Sched Plugins returns a tuple (number of pilots, message). 
* Sending to the monitor the messages returned by Sched Plugins.
* Changed setup.py, factory.py and plugins/monitor/APFMonitorPlugin.py to use release version info directly
  from factory.py rather than requiring that it be correctly placed in a config file. 
  versionTag removed from factory.conf
* Added logserver2.py, to create directory listing similar to Apache one.
* Port number is got from URL instead of from config variable baseLogHttpPort
* Method setuppandaenv() deleted from factory.py

2013-05-06

* copy_to_spool set to True
* dumping the content of queues.conf on start
* allowing raw = True or False in getContent() method in configloader
* utils distributed via /usr/share/apf instead of /usr/bin, and have different names.
* created RELEASE_NOTES
* everything related euca and persistence removed from config files. 
* created test.py, to start creating unittest-like code
* should_transfer_files = NO
* new configuration file for monitor plugins.
* wrapper examples are placed in /etc/apf/ instead of /usr/libexec/
* No more Config Plugins.
* module condor.py created. It includes htcondor python bindings. 
* Non plugin modules (jsd.py, persistence.py) moved to main directory.
* Split plugins into their own directories. 
* version number for panda userinterface package in setup.cfg
* bugs in CondorLocalWMSStatusPlugin fixed
* ReadySchedPlugin created -> Activated decommissioned
* Removing self._valid from all plugins (work in progress)
* ConfigFailure moved to apfexceptions.
* Removed hardcoded setup of periodic_remove directive from CondorLocal Batch Submit plugin.
* Not trying to create robot.txt is logserver is disabled.
* Changing directory to new HOME directory after switching identity.
* CondorNordugrid Batch Submit plugin created.
* Returning cached info object when there are problems to contact the info service in Panda Config Plugin and AGIS Config Plugin. 
* Checking condor daemon is running in CondorBase Batch Submit Plugin and Condor Batch Status Plugin.
* Created a Singleton metaclass factory. It creates metaclasses for regular Singletons and multi Singletons.
* URLs for AGIS Config Plugin and PanDA Config Plugin read from queues.conf instead of hardcoded.
* Printing the path to executable condor_q and condor_submit in debug mode.
* Using new URL for AGIS Config Plugin, and fixing code to parse new output format (a dict of dicts instead of a list of dicts).
* New URL for Panda Config Plugin.
* Added __add__() method to BatchQueueInfo and WMSQueueInfo classes.
* CondorLSF Submit plugin created.
* Euca plugins improved. Still under development. NOTE: most probably they will be removed and never used.
* New type of plugins for monitor added.
* Added factory config variable 'enablequeues'.
* ScaleSchedPlugin created.
* Sched plugins do not check for negative outputs. It has been left up to the Submit Plugin to decide what to do in that case. 
* Added some DEBUG logging messages.
* Some messages in Activated Sched Plugin moved from DEBUG logging level to INFO level.
* Bug fixed: getboolean() instead of get() when reading value of proxymanager.enabled and logmanager.enabled.
* Top logger configured as root, instead of "main".
* Log messages format includes method name for python > 2.4
* KeepNRunningSchedPlugin created.
* This release is 'Babcock' v. 2.2.0
  http://en.wikipedia.org/wiki/List_of_Characters_in_The_Passage_Trilogy#Babcock


2012-07-23

* Using new PanDA client API method getJobStatisticsWithLabel.
* GRAM CE is called OSG-CE in AGIS, instead of CE. Changed in AGISConfig Plugin.
* Pilots in STAGE-IN status are now considered to be PENDING instead or RUNNING.
* All get() calls in configloader.py have now raw=True, so interpolations wait until the very end.
* wmsqueue can be read from SchedConfig via PandaConfig Plugin, and from AGIS via AGISConfig Plugin.
* PandaConfig Plugin reads from SchedConfig variables related to CREAM CE.
* MaxToRun sched plugin created.
* CondorOSGCE submit plugin created.
* CondorDeltaCloud submit plugin created.
* Documentation in HTML format under doc/ directory.

2012-06-07

* Bumped minor release version to reflect scale of several new features, and cloud submit plugin. 
* Two new Sched Plugins to handle test queues and offline queues
* Bug in monitor.py fixed. 
* Creates robots.txt file in base of logserver docroot. 
* Added create_run_var() to init script factory. 
  It creates the subdirectory var/run/ if it does not exist, to place factory.pid
* Added $APFHEAD to init script factory. 
  This allows for user deployment on any directory, not necessarily $HOME
* Fixed the bug in Activated plugin, not returning anything under some circumstances. 
* Creating multiple Sched plugins (MinPerCycle, MaxPerCycle, MinPending, MaxPending, MaxPerFactory), 
  and code in factory.py to allow chaining more than one sched plugin.
* PandaConfig Plugin refactored to query SchedConfig in a singleton thread. 
  This is possible because it now uses an URL that delivers the entire SchedConfig content.
  Also more variables added: jdladd, environ, and special_pars.
* First draft for Euca Submit Plugin created.
* This release is the 'The Hellion' v. 2.1.1
  http://www.darylgregory.com/pandemonium/Review_NYRSF.aspx

2012-03-30

* Refactored scheduler log cleanup. Now handled in a separate thread, one for entire factory. 
  Defaults may be specified globally in factory.conf or per-queue in queues.conf 
* Added grid and vo queue attributes, and added executable.defaultarguments and executable.arguments 
  interpolation. These changes were to support wrapper.sh, runpilot3.sh, and arbitrary executables in 
  a general way. This feature uses standard Python ConfigParser interpolation. See
     http://docs.python.org/library/configparser.html
* Made Monitor object a singleton, to avoid repeated timeout delays (during queue initialization) 
  when APF monitor is unresponsive. Now there is a single attempt when single Monitor is initialized. 
* Move to wrapper 0.9.5, which checks that retrieved tarball is indeed a tarball (and not an HTML error message
  from a misbehaving HTTP proxy.  
* Fixed logic problem in Activated plugin. Now correctly assuming that Running jobs are no longer
  Activated. 
* Added specific Submit plugin for Cloud.
* Configuration objects handled as python native ConfigParser objects instead of custom
  APF objects.
* Refined running as user rather than from RPM. 'setup.py install --home=/path/to/home' does a
  user-based setup. All libs are in ~/lib/python, configs and init script in ~/etc/, and so on.
* Added an external queue configuration information plugin mechanism to enable plugin-based 
  auto-fill/overriding of config information. 
* Consolidated all plugins into hierarchical inheritance tree, to eliminate duplicated code 
  (especially the Condor plugins). 
* This release is the 'Sleeper Service' v. 2.1.0
  http://en.wikipedia.org/wiki/GSV_Sleeper_Service

2011-12-02

* Major refactorization to integrate BNL changes. Full object-oriented functional 
  plugin architecture, each running in a distinct thread. Allows for 
  end-user/third-party customization without touching core code. 
* Refined distutils usage to allow deployment as non-root in a home directory, 
  or as root in system paths. Added functionality to drop privs even when run as
  root. 
* Added typical init script and sysconfig functionality to handle shell-level/UNIX 
  concerns. 
* Added standard Linux logrotate configuration. 
* Split config system into main source for APF instance (factory.conf), proxy 
  management (proxy.conf), individual queue configuration (queue.conf). The latter 
  can be accessed as URI, paving the way to queue configuration via remote DB+URL.
* The previous change involved passing ConfigLoader objects to classes, rather than 
  passing through lists of config files. 
* Integrated batch system log export via HTTP; now uses embedded Python HTTP server. 
* Integrated proxy handling and renewal, integrated submit system log file rotation. 
* Adjusted module, file, and class names to follow Python recommended guidelines. See PEP 8:
  http://www.python.org/dev/peps/pep-0008/ 
* Moved all filehandling to factory.py script from Factory class. Factory is now purely 
  object-oriented suitable for embedding (e.g. in a web application). 
* Added copy of Jose's generic top-level wrapper to libexec/.  
* IMPORTANT: For various reasons, it was very difficult to maintain the ability to automatically
  reload configs by detecting file mtime changes. So for now simply restart if you change a file.
  This feature  can be re-enabled soon. 
* This release is "The Clockmaker". v2.0.0
  http://en.wikipedia.org/wiki/List_of_Revelation_Space_characters#The_Clockmaker

2011-03-28

* Update configuration example to Peter's new monitoring URl.
* If this is a ptest pilot use Paul's development pilot code (override with
  PILOT_HTTP_SOURCES still possible).
* This release is "The Captain". v1.2.0.
  Now the Captain called me to his bed 
  He fumbled for my hand 
  "Take these silver bars," he said 
  "I'm giving you command." 
  "Command of what, there's no one here 
  There's only you and me -
  All the rest are dead or in retreat 
  Or with the enemy." 

2011-03-17

* Only try to use python2.6 if the env var APF_PYTHON26 is defined.

2011-03-16

* Prepended "FACTORY DEBUG:" to the setup of the panda client environment
  variables which get set before logging is enabled (this confused
  some people).
* Use traceback.format_exc() to dump exceptions properly into the 
  configured factory logger ("raise" sends output to stderr).

2011-01-13

* If PANDA_URL_CONF or PANDA_URL are set then do not alter them.

2010-12-15

* Support 'allowothercountry" for beyond the pledge resources. (Default False).
* Set the PANDA_URL_CONF and PANDA_URL environment variables to use the 
  panda server squid port (25085). Suppress this by setting the APF_NOSQUID
  environment variable.
* Download of queue data also now happens via the squid cache.
* Monitoring improvement to help scale better. Removal of monitoring cron jobs.
* This is the "Silent Running" release. Look after the plants, Dewey.
  http://en.wikipedia.org/wiki/Silent_Running

2010-11-22

* Changed default sleep time to 120s.
* N.B. Monitoring requires pycurl (install standard python-curl RPM).

2010-11-05

* Wrapper now supports environment variables starting with APF_FORCE_ 
  which set the environment variable with APF_FORCE_ stripped off.
  This is needed when setting the normal environment variable via
  condor-g fails because it gets overwritten by the site shell setup.

2010-09-15

* Removed deprecated code from runpilot3-wrapper.sh (uudecode and broken
  site hacks).
* This is the "Time Out of Joint" release. This pilot factory does not 
  exist. It is a small text file on your computer containing the words
  "Pilot Factory":
  http://en.wikipedia.org/wiki/Time_Out_of_Joint

2010-07-24

* Corrected bug where "site" parameter was used instead of "siteid" to get
  panda job states (broke ANALY sites for which these are different). 
  Reported by Xavi, diagnosed by Graeme, fixed by Peter.
* Reintroduced support for CREAM CEs - factory now detects CREAM CEs and
  provides the correct JDL to condor (recommended only for use with 
  condor >= 7.5.3). See configuration example for how to support this.
* Changed JDL for gt2 GRAM sumbission from anachronistic "universe = globus"
  to "universe = grid; grid_resource = gt2 GATEKEEPER_URL".
* Changed from 'jdl' field in schedconfig to 'queue', which is a better name 
  and has the correct value for condor sites ('jdl' supported but 
  deprecated).
* Changed default proxy location to /tmp/prodRoleProxy and pilotRoleProxy.
  This can still be inherited from X509_USER_PROXY.
* Changed the default source proxy to /tmp/plainProxy.
* Changed handling of deprecated keys to rewrite the configuration objects
  themselves, which gives more robust and consistent handling. Unknown
  keys are deleted and a warning printed.
* Schedconfig download failures are now errors (not warnings).

2010-06-01

* Changed argument passed to pilot from 'site' to 'siteid', which is correct
  and necessary for ANALY_ sites.
* Added new internal status of 'error' where queue has siteid=None. This 
  suppresses pilot submission to that queue.
* Added new configuration option for the [QueueDefaults] section 
  'analysisGridProxy' which is the default proxy used for ANALY_ sites.
* Default setting for 'user' of ANALY queues is now 'user' (can still be
  overwritten). 
* ATLAS software release areas are now ordered correctly by a python code
  snippet in the wrapper which correctly compares 'rel_M-N'. 
* Updated release number to 1.0.1.
* This is the "Feersum Endjinn" release:
  http://en.wikipedia.org/wiki/Feersum_Endjinn

2010-04-09

* Added protection in submission logic against None value for 
  depthboost.
* Updated example configuration file.
* Changed configuration logic so that override = True prevents loading
  of schedconfig values only for those values set in the factory
  configuration (previously this completely supressed schedconfig
  loading).
* Renamed various parameters to their new schedconfig names (Oracle 
  column names are case insensitive, so become lower case). 
    pilotDepth -> nqueue
    pilotDepthBoost -> depthboost
    idlePilotSuppression -> idlepilotsuppression
    pilotLimit -> pilotlimit
    transferringLimit -> transferringlimit
    env -> environ
  Old names are still supported for now, but generate a warning message.
* Changed submission logic for sites in test mode to keep one pilot
  queued, but up to nqueue running (better throughput for site
  revalidation).
* Moved import exception handling to main factory.py script.

2010-03-22

* Restructured logging to inherit from main logging class (deprecated
  global logging to console). Logging now definable as an option
  (syslog, rotating file, stdout). N.B. Default logging is now to
  syslog - if you want the old behaviour set --output=stdout.
* Rewrote JDL to have separate condor log file for each individual job.
  Will help integrate with panda monitoring.
* Added limit setting code. Wrapper will always set a file size of 20GB to 
  prevent mad jobs from killing a worker node. If the queue has a memory
  limit set, then the pilot also sets this as the VMEM limit in the
  shell.
* Removed panda server Client.getSiteSpecs() call. Better to get individual
  queue statuses from schedconfig (fixes https://savannah.cern.ch/bugs/?62751) 
* Deprecated status=ok,disabled (should be online, offline). Prints warning
  for now, but remains supported.

2010-03-19

* Internal merge with latest pyfactory trunk (the old release).

2010-03-18

* Setting filesize limit (20GB) and optionally memory limit in pilot wrapper.

2010-02-11 "Tyger! Tyger!" Release (r130 factory.py; r128 runpilot3-wrapper.sh)

* Incorporated Rod's patch to support CREAM CEs.
* Corrected handling of X509_USER_PROXY environment variable and added
  explicit addition of x509userproxy to JDL.
* Proxy is now defined per queue, enabling support for multi-role pilot
  factories with recent condor versions.
* Pilot tarball now downloaded from pandaserver.cern.ch, removing one
  dependency of job workflow on the panda monitor.
* Revised runpilot3-wrapper.sh which removed explict addition of
  python library installation from the ATLAS s/w area (reversed part 2
  of change 2 from "gunpowder").
* Corrected an error in detecting OSG sites in runpilot3-wrapper.sh
  (thanks to Rod).
* Reintroduced the idlePilotNumber parameter, which controls how many
  pilots are send during an idling cycle (it's useful for stress
  testing sites).
* Fixed a race condition in the vomsrenew.sh script.
* This release is for William Blake smoking opium at Chinese New Year.

2009-11-24 "900" Release (r35 runpilot3-wrapper.sh)

* Define ATLAS_AREA internal variable
  =$VO_ATLAS_SW_DIR for EGEE sites
  =$OSG_APP/atlas_app/atlas_rel for OSG sites
* Source $ATLAS_AREA/local/setup.sh if it exists.
* This release inspired by 900GeV collisions:
  http://atlas.web.cern.ch/Atlas/public/EVTDISPLAY/atlas2009-collision-atlantis-141749-406601-hits-web.png


2009-11-05 "Gunpowder" Release (r25)

* Changed SVN repository to svn.cern.ch/reps/scotgrid/atlas/pyfactory.
  (Verison number plunged down!)
* Made wrapper more intelligent in changing system PYTHONPATH to get
  32 bit lfc module, which helps on sites with 64 bit middleware. Also
  added ATLAS python library explicitly ahead of system python to
  prevent old libraries from being loaded by accident.
* Updated wrapper script to prefer TMPDIR over EDG_WL_SCRATCH (later
  is an anachronism from the lcg-RB).
* Source DDM setup.sh to ensure pilot has access to dq2 modules.
* http://en.wikipedia.org/wiki/Gunpowder_Plot


2009-07-08 "Totoro" Release (r635)

* Introduced "country" and "group" parameters for queues. These map to
  the pilot's -o and -v options allowing for pilots which only pick up
  particular types of jobs.
* Polling for queues now intelligently uses the country and group
  options above to only send pilots when activated jobs of that type
  are present at a site.
* Introduced "cloud" option to tag a queue to a panda cloud.
* Site and cloud status are polled and if 'offline' then pilot
  submission is supressed; if a site/cloud is in 'test' status then
  the pyfactory status flips to 'test' as well (limits pilot flow).
* Introuduced 'pilotDepthBoost' parameter (default 2), which allows
  the factory to submit up to queueDepth * pilotDepthBoost into a
  non-started state if there are sufficient jobs activated. This helps
  a lot if the site has short jobs where the lags in job status
  updates mean that sites can run short of pilots. You may want to set
  this higher at T1s (especially when doing reco).
  This is a more controlled version of the short job patch which was
  released in June 2009.
* Corrected a small bug in the default queue specification so that it
  works properly.
* Renamed the 'suppression' option to 'idlePilotSuppression'.
* Distributed wrapper script is now called "runpilot3-wrapper.sh",
  which is a much more sensible name.
* Default server is now pandaserver.cern.ch.
* Updated INSTALLATION file for new panda client location in SVN.
* Updates to README, INSTALLATION, Makefile corresponding to the above
  changes.
* Eilish wanted this release called 'Totoro', after one of her
  favourite Hayao Miyazaki films,
  http://en.wikipedia.org/wiki/My_Neighbour_Totoro.


2008-10-08 "Dawn Treader" Release (r485)

* GPL license.
* Internal defaults now work properly.
* Support for multiple gatekeepers on the same site. These are
  configured as space separated lists and the factory round robins
  between them each cycle (see sample configuration file). If you use
  this a lot then an expansion syntax could be supported - ask.
* Added a new parameter "supression". If this is > 1 then an idling
  pilot is only submitted to a site every "supression" cycles. Use
  this to mollify sysadmins in your cloud who get grumpy when pilots
  don't pick up. (When the site has activated jobs submission is as
  it was before.) Caveat Emptor: this will affect brokering.
* Added new panda server parameters "server" and "port" which let the
  pilot look for jobs from a different panda server. These do not need
  to be set for most factories (default settings:
  https://pandasrv.usatlas.bnl.gov:25443).
* Added a new parameter "env" which can list extra environment
  variables to be set for the pilot by condor. (N.B. be careful if you
  set a [QueueDefaults] value for "env" - the site's value will
  _overwrite_, not add to, the environment. If there is sufficient
  demand I can change this behaviour.)
* Changed runpilot3-script-stub.sh to unset all https_proxy
  environment variables at a site as this proxy mechanism is broken
  and rarely necessary for panda server ports.
* Support for multiple configuration files. These are all loaded and
  all are reloaded if any of them change. e.g.,
  --conf=generic.conf,uk.conf,analysis.conf
  N.B. Configuration files are loaded left to right and latter
  (re)defined options overwrite earlier ones.
* Print a warning if queue "status" value is invalid.
* Ruben named this release "Dawn Treader" after his favourite Narnia
  book so far. http://en.wikipedia.org/wiki/Dawn_Treader.


2008-06-17 "Moominsummer Madness" Release (r458)

* Updated pilot http download to pandamon.usatlas.bnl.gov.
* Added a timeout to curl for pilot tarball download (30s on
  connection, 180s total).
* Fixed the cleanLogs.py script so it now deletes old archived log
  files.
* Minor changes to documentation.
* No longer including a wrapper with a pilot uuencoded into it as it's
  recommended to download the latest pilot on the fly.
* Dedication: http://en.wikipedia.org/wiki/Tove_Jansson


2008-04-16 "Umber Hulk" Release. (r442)

* Upgraded runpilot3.sh to UHURA 18f pilot.
* Modified the order of the search for an LFC compatible python. The
  ATLAS release python is now tested first (it's usually more recent
  than the OS version). N.B. This may provoke a run time python
  warning about an API mismatch between the python versions.
* Added factoryId to configuration. This allows multiple factories to
  run on the same machine. This factory ID is used as the PANDA_JSID
  passed to the panda dashboard.
* Added baseLogFileUrl to pass the correct URL for the pilot wrapper's
  logfiles to the panda dashboard.
* Added optional "user" field to allow pilots to be sent to pick up
  particular types of jobs from panda, using the "-u USER" argument.
  If this is absent or None then nothing is passed with the pilot
  arguments (i.e., pickup normal production jobs).
* Changed configuration so that each configuration section is a
  "queue" which can have a gatekeeper section. This allows pilots to
  be sent to the same queue on the CE, but having different "user"
  parameters. If there is no "gatekeeper" specified then the name of
  the configuration section name is the gatekeeper contact string, as
  before.
* New example factory configuration file, factory.conf-example makes
  use of the above clearer.
* Many internal changes to support the above feature.
* Modified the main submit code to sort alphabetically by queue name.
* cleanLogs.py now much improved. Will read factory log file directory
  location from factory.conf. Options for verbosity, days to compress
  after and days to delete after.
* This release is dedicated to Gary Gygax. d20... 19 hit!
  http://en.wikipedia.org/wiki/Gary_Gygax


2008-02-28 "Ice Moon" Release. (r436)

* Upgraded tarball to UHURA12a pilot.
* Added makefile target to rebuild the wrapper script with pilot
  tarball downloaded from subversion (you need svn installed!).
* Changed tarball http download to use BNL cache first, with fallback
  to Glasgow (Glasgow will rebuild nightly).
* Much better exception handling if there is a problem polling condor
  status or panda status - factory raises an internal exception and
  then skips a cycle.
* Added an outer level exception handler which gives instructions as
  to how to report the error then reraises error.

2008-02-08 "It's REALLY all about me" Release. (r416)

* Updated to UHURA11b2-2 pilot.


2008-02-08 "It's all about me" Release. (r410)

* Major change to pilot delivery mechanism, attaching pilot tarball as
  a uuencoded suffix of the wrapper script. This cures problems with
  batch systems which do not deliver "input" files properly on STDIN
  (bqs - there was nothing there; condor - crashes job).
  *** YOU SHOULD REMOVE THE input PARAMETER FROM factory.conf.
* Added GTAG environment variable to move towards integration with
  panda dashboard (as autopilot does).
* Fixed a bug where the factory would crash if the condor_q query
  failed (factory now raises a CondorStatusFailure exception, catches
  it and skips a cycle).
* Fixed a bug where exception arguments were improperly specified.
* Added the "-k MEM" flag to pilot where a site has a memory limit
  specified (should be used for sites lacking memory).
* Cosmetic: print timestamp at the beginning of each submit cycle.
* Upgraded to UHURA11a pilot as default.
* Improved cleanLogs.py script and renamed mkPilotWrapper.py.
</pre>



-- Main.KyleGross - 28 Aug 2015
@
