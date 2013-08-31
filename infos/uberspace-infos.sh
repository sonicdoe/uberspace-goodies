#!/usr/bin/env sh

# Ein paar Informationen eines uberspaces anzeigen
 
echo -e "\n===== SQL-Zugangsdaten ====="
cat ~/.my.cnf | grep "^user="
cat ~/.my.cnf | grep "^password="
 
echo -e "\n=== Aktuelle PHP-Version (ändern über ~/etc/phpversion) ==="
php -v | grep "^PHP "
 
echo -e "\n======== Disk Quota ========"
quota -gsl | grep -v "^Disk quotas"