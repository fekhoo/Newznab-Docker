
#Creating Config File
echo "Creating database configuration"
echo "<?php" > /config/config.php
echo "\define('DB_TYPE', '$DB_TYPE');" >> /config/config.php
echo "\define('DB_HOST', '$DB_HOST');" >> /config/config.php
echo "\define('DB_PORT', $DB_PORT);" >> /config/config.php
echo "\define('DB_USER', '$DB_USER');" >> /config/config.php
echo "\define('DB_PASSWORD','$DB_PASSWORD');" >> /config/config.php
echo "\define('DB_NAME', '$DB_NAME');" >> /config/config.php
echo "\define('DB_INNODB', true);" >> /config/config.php
echo "\define('DB_PCONNECT', true);" >> /config/config.php
echo "\define('DB_ERRORMODE', PDO::ERRMODE_SILENT);" >> /config/config.php
echo "\define('NNTP_USERNAME', '$NNTP_USERNAME');" >> /config/config.php
echo "\define('NNTP_PASSWORD', '$NNTP_PASSWORD');" >> /config/config.php
echo "\define('NNTP_SERVER', '$NNTP_SERVER');" >> /config/config.php
echo "\define('NNTP_PORT', '$NNTP_PORT');" >> /config/config.php
echo "\define('NNTP_SSLENABLED', $NNTP_SSLENABLED);" >> /config/config.php
echo "\define('CACHEOPT_METHOD', 'none');" >> /config/config.php
echo "\define('CACHEOPT_TTLFAST', '120');" >> /config/config.php
echo "\define('CACHEOPT_TTLMEDIUM', '600');" >> /config/config.php
echo "\define('CACHEOPT_TTLSLOW', '1800');" >> /config/config.php
echo "\define('CACHEOPT_MEMCACHE_SERVER', '127.0.0.1');" >> /config/config.php
echo "\define('CACHEOPT_MEMCACHE_PORT', '11211');" >> /config/config.php
echo "\require("automated.config.php");" >> /config/config.php
