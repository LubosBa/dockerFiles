#!/bin/bash


if [ ! -f /data/ibdata1 ]; then

	mysql_install_db --datadir=/data

	/usr/bin/mysqld_safe --defaults-file=/config/my.cnf &
	sleep 10s
	echo "Setting DB password"
	echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'admin12340!' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql --port=3306 -h 127.0.0.1
	echo "Killing mysqld"

	killall mysqld
	sleep 10s
fi

echo "Starting mysql instance"
/usr/bin/mysqld_safe --defaults-file=/config/my.cnf
