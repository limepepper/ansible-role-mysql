
LimePepper MySQL Ansible Role
=========

The purpose of this role is to install and start a mysql compatible database
service, and to secure the installation, and make the service available to other
roles requiring a mysql compatible database.

The role is compatible with any of the major current linux distros. See the
testing section for details.

The role supports variables to control which package and version of mysql/maria
is installed, and allows over riding of generated passwords, ports etc.

This role is primarily designed to be used as a dependency by other limepepper
roles. The aim of this role is to support deploying the commonly avaiable
mysql/maria/community and 3rd party forks of the server to the most common
platforms.

## Minimal Configuration

A minimal use of this role will do the following;

- Install the stock package from the distro repo
- set a complex root password.
- delete/disable the test user account

A basic playbook looks like this.

~~~ ansible
- hosts: all
  become: yes

  tasks:
  - import_role:
      name: limepepper.mysql
~~~

By default, if no `mysql_root_password` variable is provided, the role will
generate a 15 character complex password, and write it out into a file called
`~/.local/share/ansible/store/limepepper.mysql/{{ inventory_hostname }}/mysql_root_password`



## Install a specific package and version

You can set a `mysql_profile` variable which will control which package and
version is installed. (not all combinations are available on all distro versions)

~~~ ansible
- hosts: all
  become: yes

  tasks:
  - import_role:
      name: limepepper.mysql
    vars:
      mysql_profile: mysql_server_5_1
~~~

## Available packages and versions

Along with the official MySQL packages, there are several groups releasing
mysql/mariadb compatible packages. This role recognises the following
package-version combinations.

| Release | repo |
|-----------|:-------------:|
| mysql_official_5_5 |	Oracle Official |
| mysql_official_5_6 |	Oracle Official |
| mysql_official_5_7 |	Oracle Official |
| mysql_community_5_6 |	MySQL community |
| mysql_community_5_7 |	MySQL community |
| mysql_community_8_0 |	MySQL community |
| maria_5_1 |	MariaDB |
| maria_5_2 |	MariaDB |
| maria_5_3 |	MariaDB |
| maria_5_5 |	MariaDB |
| maria_10_0 | MariaDB |
| maria_10_1 | MariaDB |
| maria_10_2 | MariaDB |
| maria_10_3 | MariaDB |



## set mysql root password

To override the generated password, use the following variable..
~~~
vars:
  mysql:
    mysql_root_password: some_difficult_password
~~~


MySQL Versions
--------------

The following were taken from the mysql and maria wikipedia pages, and represent
the target versions that we are testing against.

| Release        | General availability     | Latest minor version  | Latest release |
|:-------------:|:-------------:| :-----:| ------------- |:---------------| -----:|
| 5.1 |	2008-11-14 | 5.1.73 |	2013-12-03
| 5.5	| 2010-12-03 | 5.5.59	|2018-01-15
| 5.6	| 2013-02-05 | 5.6.39	|2018-01-15
| 5.7	| 2015-10-21 | 5.7.21	|2018-01-15
| 8.0	| N/A	      | 8.0.4 rc |2018-01-23


Maria Versions
-------------

https://en.wikipedia.org/wiki/MariaDB

| Version |	Original release date | 	Latest version| 	Release date | 	Status
|:-------------:|:-------------:| :-----:| ------------- |:---------------| -----:|
| 5.1	  | 2009-10-29 |	5.1.67	| 2013-01-30|	Stable (GA)
| 5.2	  | 2010-04-10 |	5.2.14	| 2013-01-30|	Stable (GA)
| 5.3	  | 2011-07-26 |	5.3.12	| 2013-01-30|	Stable (GA)
| 5.5	  | 2012-02-25 |	5.5.59	| 2018-01-19|	Stable (GA)
| 10.0	| 2012-11-12 |	10.0.34	| 2018-01-30|	Stable (GA)
| 10.1	| 2014-06-30 |	10.1.31	| 2018-02-06|	Stable (GA)
| 10.2	| 2016-04-18 |	10.2.13	| 2018-02-13|	Stable (GA)
| 10.3	| 2017-04-16 |	10.3.4	| 2018-01-18|	Beta






A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.


~~~~
# Needed to create system tables
ExecStartPre=/usr/bin/mysqld_pre_systemd

# Start main service
ExecStart=/usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid $MYSQLD_OPTS

# Use this to switch malloc implementation
EnvironmentFile=-/etc/sysconfig/mysql
~~~~


# set up ssl
https://www.chriscalender.com/tag/require-ssl/
