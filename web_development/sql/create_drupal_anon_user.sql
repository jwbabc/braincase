ALTER TABLE users MODIFY COLUMN uid int(10) NOT NULL AUTO_INCREMENT;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
INSERT INTO users (uid, name, pass, mail, mode, sort, threshold, theme, signature, created, access, login, status, timezone, language, picture, init, data,signature_format) VALUES ('0', '', '', '', 0, 0, 0, '', '', 0, 0, 0, 0, NULL, '', '', '', NULL, 2);