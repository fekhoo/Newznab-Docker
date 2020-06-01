# Newznab+ Docker

newznab is a usenet indexing application, that makes building a usenet community easy. http://www.newznab.com/
This is a ubuntu docker image with newznab Plus intended for use on unraid server.

## Requirements
- You need a seperate MySQL server.
- Newznab SVN user name and password.
- NewznabID.

## Installation

Run the following comand, change variables to match your settings

```
docker run --restart=always -d -p 80:80 \
	--hostname=newznab \
	--name=newznab \
	-v <Distenation to covers folder>:/var/www/newznab/www/covers \
	-v <Distenation to nzb folder>:/var/www/newznab/nzbfiles \
	-e 'TZ=America/Newy_York' \
	-e 'NNUSER=svnuser' \
	-e 'NNPASS=svnpw' \
	-e 'DB_TYPE=mysql' \
	-e 'DB_HOST=localhost' \
	-e 'DB_PORT=3306' \
	-e 'DB_USER=user' \
	-e 'DB_PASSWORD=password' \
	-e 'DB_NAME=newznab' \
	-e 'NNTP_USERNAME=nnuser' \
	-e 'NNTP_PASSWORD=nnpw' \
	-e 'NNTP_SERVER=server.com' \
	-e 'NNTP_PORT=569' \
	-e 'NNTP_SSLENABLED=true' \
	
```
Go to http://yourserver/install and setup data base, usenet server, and admin user account

