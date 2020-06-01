# Newznab+ Docker

newznab is a usenet indexing application, that makes building a usenet community easy. http://www.newznab.com/
This is a ubuntu docker image with newznab Plus intended for use on unraid server. This is still a work in progress, but it works fine!

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
Go to http://yourip:yourport/install and follow the installation wizard to the end. After completing the installation go to the admin edit site http://yourip:yourport/admin/site-edit.php and set up some paths and config options:
	
```
- newznabID : <use your owen ID>
- unrar path : /usr/bin/unrar
- mediainfo path : /usr/bin/mediainfo
- ffmpeg path : /usr/bin/ffmpeg
- lame path : /usr/bin/lame
- check for password : deep
- delete passworded releases : yes
```

### Variables

| Variable | Meaning |
| --- | --- |
| `TZ` | Time Zone example `America/New_York`. |
| `NNUSER` | Newznab plus user name for svn downlaod. |
| `NNPASS` | Newznab plus password for svn downlaod. |
| `DB_TYPE` | Database type 'Mysql'. |
| `DB_HOST` | Database location 'localhost'. |
| `DB_PORT` | Database port '3306'. |
| `DB_USER` | Database user 'root'. |
| `DB_PASSWORD` | Database user password.|
| `NNTP_USERNAME` | Usenet provider user name. |
| `NNTP_PASSWORD` | Usenet provider password. |
| `NNTP_SERVER` | Usenet provider server address. |
| `NNTP_PORT` | Usenet provider port number. |
| `NNTP_SSLENABLED` | Usenet provider SLL true or false. |


