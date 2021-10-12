phpmyadmin: /docker-entrypoint-pma.sh apache2-foreground
dockergen: docker-gen -watch -notify "apache2ctl restart" /pma-config.tmpl /etc/phpmyadmin/config.inc.php
