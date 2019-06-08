#!/bin/sh
#Functions

# Display a text with colors
display(){
  text="$1"

  case "$2" in
   "Green") echo -e '\033[0;32m' "###### $text  ######" '\033[0m'
   ;;
   "Blue") echo -e '\033[0;34m' "** $text  **" '\033[0m'
   ;;
   "Red") echo -e '\033[0;31m' "!! $text  !!" '\033[0m'
   ;;
   "Brown") echo -e '\033[0;33m' "- $text" '\033[0m'
   ;;
   "Purple") echo -e '\033[0;35m' "- $text" '\033[0m'
   ;;
esac  
}

# Execute an SQL statement
execute(){
  statement="$1"
  display "SQL > $statement" "Purple"
  mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e"$statement"
}

# Import a SQL database
import(){
  database="$1"
  options="$2"
  mysql -uroot -p"$MYSQL_ROOT_PASSWORD" $options < $database
}

# Script

display "MariaDB Installation" "Green"

display "Environment variables" "Blue"
printenv

display "Checking Socket folder ..." "Blue"
# Change permissions for the socket
if [ -d "/run/mysqld" ]; then
	display "Socket folder already present, skipping creation" "Brown"
else
	display "Socket folder not found, creating...." "Brown"
	mkdir -p /run/mysqld
fi

display "Change permission for the socket folder" "Brown"
chown -R mysql:mysql /run/mysqld

# Change permissions for the Mysql dir
display "Change permission for $DB_DATA_PATH" "Brown"
chown -R mysql:mysql ${DB_DATA_PATH}
ls -la ${DB_DATA_PATH}

display "Checking for a MariaDB installation in $DB_DATA_PATH ..." "Green"
if [ -d ${DB_DATA_PATH}/mysql ]; then
	display "MariaDB installation already present in $DB_DATA_PATH/mysql, skipping installation" "Blue"
else
  display "MariaDB data directory not found, starting installation"	"Blue"

  # Install Mariadb
  display 'MariaDB init process in progress...' "Brown"
  mysql_install_db --user=mysql --datadir=$DB_DATA_PATH
  display "MariaDB initialized"	"Brown"

  display "Starting MariaDB"
  mysqld_safe --nowatch

  until [ -e /run/mysqld/mysqld.sock ]; do
    display "Wait for MariaDB has started ..." "Brown"
    sleep 1
  done

  if [ -e /run/mysqld/mysqld.sock ]; then
    display "Socket is ready " "Brown"
    ls -la /run/mysqld
    display "MariaDB is started" "Brown"
  fi  

  display "Configure Root password : $MYSQL_ROOT_PASSWORD" "Blue"
  mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"

  display "Configure databases" "Blue"

  display "Remove useless Users in mysql" "Brown"
  execute "select host, user, password from mysql.user;"
  execute "DELETE FROM mysql.user WHERE user NOT IN ('mysql.sys', 'mysqlxsys', 'root') OR host NOT IN ('localhost') ;"
  execute "FLUSH PRIVILEGES;"
  execute "select host, user, password from mysql.user;"
  execute "show grants;"

  display "Remove useless tables" "Brown"
  execute "show databases;"
  execute "DROP DATABASE IF EXISTS test;"
  execute "show databases;"

  if [ "$MYSQL_DATABASE" != "" ]; then
    display "Create database : $MYSQL_DATABASE" "Brown"
    execute "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
    execute "show databases;"
  fi

  if [ "$MYSQL_USER" != "" ]; then
        display "Creating user: $MYSQL_USER with password $MYSQL_PASSWORD" "Brown"
        execute "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
        execute "select host, user, password from mysql.user;"

        # grant privilege to the user for the database.
        if [ "$MYSQL_DATABASE" != "" ]; then
            display "Grant privileges to $MYSQL_USER for $MYSQL_DATABASE" "Brown"
            execute "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
            execute "FLUSH PRIVILEGES ;"
            execute "show grants;"
        fi
  fi

  display 'Looking for others scripts or databases to import in "initdb.d"' "Brown"
  for file in /initdb.d/*; do
    case "$file" in
      *.sh)       display "Running $file" "Purple"; ./$file;;
      *.sql)      display "Import $file" "Purple"; import $file;;
      *.sql.gz)   display "Extract $file and import it" "Purple"; gunzip -c "$file" | mysql -uroot -p$MYSQL_ROOT_PASSWORD;;
      *)          display "Don't proceed $file : extension unknown" "Purple";;
    esac
  done

  display 'Shutdown MySQL server' "Green"
  mysqladmin -uroot -p"$MYSQL_ROOT_PASSWORD"  shutdown

	display 'MySQL init process done. Ready for start up.' "Green"
fi

chown -R mysql:mysql $DB_DATA_PATH

exec "$@"