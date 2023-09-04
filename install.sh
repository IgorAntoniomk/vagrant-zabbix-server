!# bin/bash 
echo "Install Zabbix repository "
sudo wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu20.04_all.deb
sudo dpkg zabbix-release_6.0-4+ubuntu20.04_all.deb
sudo apt update
sudo apt install -y apache2
echo "Install Zabbix server, frontend, agent "
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

echo " install Mysql"
sudo apt-get install -y mysql-server

echo "Create initial database"
sudo mysql -uroot 
sudo mysql -uroot -e "create database zabbix character set utf8mb4 collate utf8mb4_bin"
sudo mysql -uroot -e "create user zabbix@localhost identified by 'password'"
sudo mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost"
sudo mysql -uroot -e "set global log_bin_trust_function_creators = 1"
sudo mysql -uroot -e "quit" 

echo "importing database"
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix 
sudo mysql -uroot -p set global log_bin_trust_function_creators = 0;

echo "configuring database"
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix 
sudo mysql -uroot -e "set global log_bin_trust_function_creators = 0;"
echo -e 'DBPassword=password' >> /etc/zabbix_server.conf 

echo "restarting services"
sudo systemctl restart apache2
sudo systemctl restart zabbix-server zabbix-agent 

echo "Enabling services"
sudo systemctl enable apache2
sudo systemctl enable zabbix-server zabbix-agent 

