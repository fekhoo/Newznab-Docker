<?php

//=========================
// Config you must change - updated by installer.
//=========================
define('DB_TYPE', 'mysql');
define('DB_HOST', 'localhost');
define('DB_PORT', 3306);
define('DB_USER', 'root');
define('DB_PASSWORD', 'password');
define('DB_NAME', 'newznab');
define('DB_INNODB', true);
define('DB_PCONNECT', true);
define('DB_ERRORMODE', PDO::ERRMODE_SILENT);

define('NNTP_USERNAME', 'nnuser');
define('NNTP_PASSWORD', 'nnpass');
define('NNTP_SERVER', 'nnserver');
define('NNTP_PORT', '563');
define('NNTP_SSLENABLED', true);

define('CACHEOPT_METHOD', 'memcache');
define('CACHEOPT_TTLFAST', '120');
define('CACHEOPT_TTLMEDIUM', '600');
define('CACHEOPT_TTLSLOW', '1800');
define('CACHEOPT_MEMCACHE_SERVER', '127.0.0.1');
define('CACHEOPT_MEMCACHE_PORT', '11211');
define('CACHEOPT_REDIS_SERVER', '127.0.0.1');
define('CACHEOPT_REDIS_PORT', '6379');

// define('EXTERNAL_PROXY_IP', ''); //Internal address of public facing server
// define('EXTERNAL_HOST_NAME', ''); //The external hostname that should be used

require("automated.config.php");
