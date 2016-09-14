# To create users
CREATE USER 'user'@'::1' IDENTIFIED BY 'password';
CREATE USER 'user'@'127.0.0.1' IDENTIFIED BY 'password';
CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';
# To allow access from production servers
CREATE USER 'user'@'ip' IDENTIFIED BY 'password';
CREATE USER 'user'@'ip' IDENTIFIED BY 'password';
# To change a password
SET PASSWORD FOR 'user'@'127.0.0.1' = PASSWORD('password');
# To grant all privileges on all DBs (Super User)
GRANT ALL PRIVILEGES ON *.* TO 'user'@'::1';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'127.0.0.1';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';
# To grant privileges to specific DBs
GRANT ALL PRIVILEGES ON db_name.* TO 'user'@'ip';
# To revoke privileges
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'user'@'ip';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'user'@'ip';
# Always do this after chaning permissions
FLUSH PRIVILEGES;

# A more locked down version for external projects
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON databasename.* TO 'username'@'localhost' IDENTIFIED BY 'password';