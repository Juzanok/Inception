#!/bin/bash

if [ -f ./wp-config.php ]; then
	echo "Wordpress is already setup"
else
	echo "Downloading WordPress..."
	wget https://wordpress.org/latest.zip
	unzip latest.zip
	cp -rf wordpress/* .
	rm -rf wordpress latest.zip

	echo "Setting up wp-config.php..."
	cat << EOF > ./wp-config.php
<?php
define ( 'DB_NAME', '${DB_NAME}' );
define ( 'DB_USER', '${DB_USER}' );
define ( 'DB_PASSWORD', '${DB_PASSWORD}' );
define ( 'DB_HOST', 'mariadb' );
define ( 'DB_CHARSET', 'utf8' );
define ( 'DB_COLLATE', '' );
define ( 'WP_DEBUG', false );
\$table_prefix = 'wp_';
if ( ! defined( 'ABSPATH' ) ) {	
	define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
EOF

	echo "wp core install"
	wp core install --allow-root --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USR} --admin_password=${WP_ADMIN_PWD} --admin_email=${WP_ADMIN_EMAIL}

	echo "wp user create..."
	wp user create --allow-root ${WP_USR} ${WP_EMAIL} --user_pass=${WP_PWD};

	echo "Wordpress is ready"
fi

exec "$@"