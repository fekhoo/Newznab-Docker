# Newznab-Unraid
under work

Docker Newznab plus 
An image running ubuntu and Newznab Plus intended for unraid server, however I am sure it can be run

Requirements
- You need a seperate MySQL docker.
- SVN user name and password.
- NewznabID

Installation

docker run --restart=always -d -p 8800:80 \
	--hostname=newznab \
	--name=newznab \
	-v <hostdir_where_config_will_persistently_be_stored>:/config \
	-e 'TZ=America/Newy_York' \
	-e 'SPOTWEB_DB_TYPE=pdo_mysql' \
