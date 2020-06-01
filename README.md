# Newznab+ Docker

newznab is a usenet indexing application, that makes building a usenet community easy. http://www.newznab.com/
This is a ubuntu docker image with newznab Plus intended for use on unraid server.

Requirements
- You need a seperate MySQL server.
- Newznab SVN user name and password.
- NewznabID.

Installation

docker run --restart=always -d -p 8800:80 \
	--hostname=newznab \
	--name=newznab \
	-e 'TZ=America/Newy_York' \
	-e 'NNUSER=svnuser' \
	-e 'NNPASS=svnpw' \
	-e 'DB_TYPE=mysql' \
	-e 'DB_HOST=localhost' \
	-e 'DB_PORT=3306' \
	-e 'DB_USER=user' \
	-e 'DB_PASSWORD=password' \
	-e 'NNTP_USERNAME=nnuser' \
	-e 'NNTP_PASSWORD=nnpw' \
	-e 'NNTP_SERVER=server.com' \
	-e 'NNTP_PORT=569' \
	-e 'NNTP_SSLENABLED=true' \
	
	For the first run go to http://yourserver/install   and step through the installer - This forces a Build of the Database in MYSQL and creates a user.
	
