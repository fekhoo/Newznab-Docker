<?php

//=========================
// Config you must change - updated by installer.
//=========================
define('DB_TYPE', 'mysql');
define('DB_HOST', '10.35.103.127');
define('DB_PORT', 3306);
define('DB_USER', 'root');
define('DB_PASSWORD','my-secret-pw');
define('DB_NAME', 'newznab');
define('DB_INNODB', true);
define('DB_PCONNECT', true);
define('DB_ERRORMODE', PDO::ERRMODE_SILENT);

define('NNTP_USERNAME', 'fekhoo');
define('NNTP_PASSWORD', 'fekhoo14');
define('NNTP_SERVER', 'news.newsgroup.ninja');
define('NNTP_PORT', '563');
define('NNTP_SSLENABLED', true);

define('CACHEOPT_METHOD', 'none');
define('CACHEOPT_TTLFAST', '120');
define('CACHEOPT_TTLMEDIUM', '600');
define('CACHEOPT_TTLSLOW', '1800');
define('CACHEOPT_MEMCACHE_SERVER', '127.0.0.1');
define('CACHEOPT_MEMCACHE_PORT', '11211');

// define('EXTERNAL_PROXY_IP', '10.35.103.127'); //Internal address of public facing server
// define('EXTERNAL_HOST_NAME', ''); //The external hostname that should be used

require("automated.config.php");
