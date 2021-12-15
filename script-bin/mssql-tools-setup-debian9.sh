#!/usr/bin/env bash

# This script installs the Microsoft ODBC connector to SQL server,
# it also installs the command line utilities to interact with SQL server.
#
# ATTENTION
# It works on Debian 9 (stretch), although it is based on the APT repository
# for Debian 8 (jessie).
#
# based on:
# https://askubuntu.com/questions/850957/how-do-i-install-mssql-server-and-or-tools-for-linux-on-16-04#850958
# cf also:
# https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools

sudo su <<ROOT_STUFF
echo -e "\n\nSetup Microsoft apt repository\n\n"
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-server.list

echo -e "\n\nSetup locales\n\n"
apt-get install locales
sed -i "s/^# en_US/en_US/" /etc/locale.gen && locale-gen en_US en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ROOT_STUFF

echo -e "\n\nRefresh the list of APT available packages\n\n"
sudo apt-get update

echo -e "\n\nShow the dependencies for mssql-tools\n\n"
apt-cache depends mssql-tools

echo -e "\n\nInstall mssql-tools\n\n"
# sudo apt-get --purge remove -y msodbcsql mssql-tools
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools
sudo chown -R `whoami`:`whoami` /opt/mssql-tools
echo -e "# Microsoft tools for SQL Server\nexport PATH=/opt/mssql-tools/bin:\$PATH\n" >> ~/.bashrc

# if in need of debugging SQL queries:
# echo "Trace = Yes" >> /etc/odbcinst.ini
# echo "TraceFile = /var/log/odbc.log" >> /etc/odbcinst.ini

echo -e "\n\n   >>> You must run: 'source ~/.bashrc'\n\n"
