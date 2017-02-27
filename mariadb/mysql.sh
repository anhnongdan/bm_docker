#!/bin/bash
mkdir -p /tmp/mysql
sed "s/__DB_PORT__/$DB_PORT/g" /etc/mysql/my.cnf.orig > /etc/mysql/my.cnf
sed -i -r 's/bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

chown mysql.mysql -R /tmp/mysql /var/lib/mysql
VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MariaDB volume is detected in $VOLUME_HOME"
    echo "=> Installing MariaDB ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MariaDB service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done


	for DB_DATABASE in $DB_DATABASES;do
		echo "=> Creating database $DB_DATABASE"
		mysql -uroot -e "CREATE DATABASE $DB_DATABASE;"
		mysql -uroot -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS'"
		mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION"
		mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION"
	done
	mysqladmin -uroot shutdown
	if [ -f "$VOLUME_HOME/start.sh" ];then 
		chmod -x $VOLUME_HOME/start.sh
		sh $VOLUME_HOME/start.sh init
	fi 
else
    echo "=> Using an existing volume of MariaDB"
fi

echo "=> Done!"

if [ -f "$VOLUME_HOME/start.sh" ];then 
	chmod -x $VOLUME_HOME/start.sh
	sh $VOLUME_HOME/start.sh
fi 
exec mysqld_safe
