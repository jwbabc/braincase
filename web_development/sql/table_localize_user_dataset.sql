CREATE TABLE IF NOT EXISTS localize_user_dataset (
  localize_user_dataset_id int(11) NOT NULL AUTO_INCREMENT,
  uid INT( 11 ) NOT NULL DEFAULT '0',
  ip int(10) NOT NULL DEFAULT '0',
  latitude decimal(18,12) NOT NULL,
  longitude decimal(18,12) NOT NULL,
  zip_code int(5) NOT NULL,
  dma varchar(50) DEFAULT NULL,
  affiliate varchar(4) DEFAULT NULL,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (localize_user_dataset_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Localization data for localize_user module' AUTO_INCREMENT=1;