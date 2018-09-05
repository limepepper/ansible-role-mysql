


update mysql.user SET PASSWORD=PASSWORD('{{ mysql_root_password }}') WHERE USER='root';

flush privileges;