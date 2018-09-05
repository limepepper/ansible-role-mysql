SET @@SESSION.SQL_LOG_BIN=0;
{#
##    ___  _
##   |   \| |__  __ _   _  _ ___ ___ _ _
##   | |) | '_ \/ _` | | || (_-</ -_) '_|
##   |___/|_.__/\__,_|  \_,_/__/\___|_|
##
#}
{#
    login account used for resetting the root password.
    This needs to be done first in case anything else fails and locks it out
    It should have the minimal permissions necessary to reset the root password
    i.e. UPDATE on mysql.user and RELOAD, to flush privileges
#}
{% if mysql_dba_account %}
{% if mysql_requested_version|version_compare('5.7.6', '>=', strict=True) %}
CREATE USER IF NOT EXISTS '{{ mysql_dba_user }}'@'localhost' IDENTIFIED BY '{{ mysql_dba_password }}';
{% else %}
GRANT ALL ON `mysql`.* TO '{{ mysql_dba_user }}'@'localhost' IDENTIFIED BY '{{ mysql_dba_password }}';
{% endif %}
-- GRANT ALL PRIVILEGES ON mysql.* TO '{{ mysql_dba_user }}'@'localhost';
GRANT INSERT(user) ON mysql.user TO '{{ mysql_dba_user }}'@'localhost';
GRANT UPDATE(user) ON mysql.user TO '{{ mysql_dba_user }}'@'localhost';
GRANT RELOAD ON *.* TO '{{ mysql_dba_user }}'@'localhost';
{% if mysql_requested_version|version_compare('5.6.6', '>=', strict=True) %}
UPDATE mysql.user SET Password_expired='N' WHERE User='{{ mysql_dba_user }}';
{% endif %}
{% if mysql_requested_version|version_compare('5.7.6', '>=', strict=True) %}
UPDATE mysql.user SET account_locked='N' WHERE User='{{ mysql_dba_user }}';
{% endif %}
{% endif %}
{#
##    _   _                     _                                   _
##   | | | |_ _    _____ ___ __(_)_ _ ___   __ _ __ __ ___ _  _ _ _| |_ ___
##   | |_| | ' \  / -_) \ / '_ \ | '_/ -_) / _` / _/ _/ _ \ || | ' \  _(_-<
##    \___/|_||_| \___/_\_\ .__/_|_| \___| \__,_\__\__\___/\_,_|_||_\__/__/
##                        |_|
# "If users are created expired, re-enable the root/dba account"
# the Password_expired field was introduced around 5.6.6 todo add link
#}
{% if mysql_requested_version|version_compare('5.6.6', '>=', strict=True) %}
UPDATE mysql.user SET Password_expired='N' WHERE User='root';
{% if mysql_dba_account %}
UPDATE mysql.user SET Password_expired='N' WHERE User='{{ mysql_dba_user }}';
{% endif %}
{% endif %}
{% if mysql_requested_version|version_compare('5.7.6', '>=', strict=True) %}
UPDATE mysql.user SET account_locked='N' WHERE User='root';
{% endif %}
{#
##      _       _   _      __  __     _   _            _
##     /_\ _  _| |_| |_   |  \/  |___| |_| |_  ___  __| |___
##    / _ \ || |  _| ' \  | |\/| / -_)  _| ' \/ _ \/ _` (_-<
##   /_/ \_\_,_|\__|_||_| |_|  |_\___|\__|_||_\___/\__,_/__/
##
#       Configure alternative auth plugin methods
##              _   _                  _       _
##    __ _ _  _| |_| |_    ___ ___  __| |_____| |_
##   / _` | || |  _| ' \  (_-</ _ \/ _| / / -_)  _|
##   \__,_|\_,_|\__|_||_|_/__/\___/\__|_\_\___|\__|
##                     |___|
{# "if root_auth_method == 'auth_socket' enable it for the root user" #}
{% if mysql_root_auth_method == 'auth_socket' %}
update mysql.user set plugin = 'auth_socket' WHERE User = 'root' and Host = 'localhost';
DELETE FROM mysql.user WHERE User = 'root' and plugin != 'auth_socket';
{% elif mysql_root_auth_method == 'mysql_native_password' %}
{#
##              _   _                                               _
##    _ _  __ _| |_(_)_ _____    _ __  __ _ _______ __ _____ _ _ __| |
##   | ' \/ _` |  _| \ V / -_)  | '_ \/ _` (_-<_-< V  V / _ \ '_/ _` |
##   |_||_\__,_|\__|_|\_/\___|__| .__/\__,_/__/__/\_/\_/\___/_| \__,_|
##                          |___|_|
# "Mysql Version 5.7.6 or greater"
#}
    {% if mysql_requested_version|version_compare('5.7.6', '>=', strict=True) %}
{# "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test';" #}
-- setting password using strategy for version > mysql-5.7.6
update mysql.user set plugin = 'mysql_native_password' WHERE User = 'root' and Host = 'localhost';
ALTER USER 'root'@'localhost' IDENTIFIED BY '{{ mysql_root_password }}';
    {% elif mysql_requested_version|version_compare('5.6', '=', strict=True)  %}
-- setting password using strategy for version ~= mysql-5.6
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('{{ mysql_root_password }}');

    {% elif mysql_requested_version|version_compare('5.5', '=', strict=True)  %}
-- setting password using strategy for mysql == 5.5
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('{{ mysql_root_password }}');
    {% elif mysql_requested_version|version_compare('5.5', '<', strict=True)  %}
-- setting password using strategy for version < mysql-5.5
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('{{ mysql_root_password }}');
    {% else %}
-- setting password using strategy for version "other"
UPDATE mysql.user SET authentication_string = PASSWORD('{{ mysql_root_password }}'), plugin = 'mysql_native_password' WHERE User = 'root' AND Host = 'localhost';
update mysql.user set plugin = 'mysql_native_password' WHERE User = 'root' and Host = 'localhost';
    {% endif %}
{% else %}
{# other default auth method requested #}
{% endif %}
{#
##    ___                        ___         _        _ _
##   / __| ___ __ _  _ _ _ ___  |_ _|_ _  __| |_ __ _| | |
##   \__ \/ -_) _| || | '_/ -_)  | || ' \(_-<  _/ _` | | |
##   |___/\___\__|\_,_|_| \___| |___|_||_/__/\__\__,_|_|_|
##
#   "to pass mysql-baseline inspec profile, delete any no-user accounts"
#   "delete test database"
#}
{% if mysql_remove_nouser_accounts %}
DELETE FROM mysql.db WHERE User = '';
DELETE FROM mysql.columns_priv WHERE User = '';
DELETE FROM mysql.user WHERE User = '';
{% endif %}
{% if mysql_remove_test_databases %}
DROP DATABASE IF EXISTS test;
{% endif %}
{#
##    ___                        ___          _
##   / __| ___ __ _  _ _ _ ___  | _ \___  ___| |_
##   \__ \/ -_) _| || | '_/ -_) |   / _ \/ _ \  _|
##   |___/\___\__|\_,_|_| \___| |_|_\___/\___/\__|
##
#   "to pass mysql-baseline inspec profile, root must be secured"
#}
DELETE FROM mysql.db WHERE User = 'root' and Host != 'localhost';
DELETE FROM mysql.user WHERE User = 'root' and Host != 'localhost';
-- flush privileges;



