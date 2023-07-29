#!/bin/sh

mysql_install_db

service mysql start

if mysql -u root -p"${DB_ROOT_PASSWORD}" -e "USE ${DB_NAME}"; then
    echo "Database was already created"
else
	echo "Creating database"
    mysql_secure_installation << _EOF_
    
    Y
    $DB_ROOT_PASSWORD
    $DB_ROOT_PASSWORD
    Y
    n
    Y
    Y
_EOF_

    mysql -u root -p"${DB_ROOT_PASSWORD}" << _EOF_
    CREATE DATABASE IF NOT EXISTS ${DB_NAME};
    GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
_EOF_

fi

service mysql stop

exec "$@"