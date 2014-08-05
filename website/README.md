Layout
=====================

The website is split two **independent** parts. 
(Which if needed could run on two different machines.)

The **Frontend** is the UI which provides the tool and feel of the system, this
system requires no databases.

The **Tracker** is the backend which keeps track of stats about the system. It
is only accessed through a JSON API.

For how this website fits into the overall streaming system look at the following diagram;
![Streaming System overall Diagram](https://docs.google.com/drawings/d/1ZN5uqd-fo62e0IZSzuOSo6YadRY_n7umkUThmqckACA/pub?w=960&h=720)

For how the website fits into the overall TimVideos.us project, look at the
following diagram:
![TimVideos.US overall Diagram](https://docs.google.com/drawings/d/1crkdqukOAV9Alq9BOMFucDmwc_HD6qnJ4OF5MJpkrLg/pub?w=960&h=720)


Initial Configuration
=====================

To get the code and dependencies, as a **non-root user**:

```bash
git clone git@github.com:timvideos/streaming-system.git
cd streaming-system/website

cp private/settings.py.example private/settings.py
vi private/settings.py

sudo apt-get install python-dev python-pip || sudo yum install python-devel python-pip
sudo pip install virtualenv
```



Running a test server
=====================

Run ``make testserve``; this will configure a virtualenv, download and install
dependencies (inside the virtualenv; your system will not be touched); and a
test server will be started.

If you recieve a "bin/activate" error, try ```make distclean``` and try again. 

If this is your first time running ``make testserve`` you'll be prompted to provide
a username and password for an admin account.

This test server should not be used in production (see relevant section below).

Requests are served at http://127.0.0.1:8000 by default.  If you need to change
the listening IP or port, try ```ARGS="192.168.1.1:8000" make testserve``` where ARGS
represents your desired listening IP and port.

This test server **should NOT be used in production** (see relevant section below).



Registering a (fake) flumotion encoder server onto tracker
==========================================================

The frontend will only show rooms which are available on the tracking module.

The register.py command is normally used on a flumotion encoder machine to
register the encoder's existence. If you are not running an encoder machine
locally, you can use the fake_register command to pretend you have one.

```
# cd ../tools/register
# ../../website/bin/python fake_register.py --ip 127.0.0.1
```

Sample output:

```
Registered example at 2013-04-24 09:32:43.961403 result OK
Registered example at 2013-04-24 09:32:45.130072 result OK
...
```

This keeps on going.

Open http://127.0.0.1:8000/example to view the page

Note: DO NOT run ``make testserve`` as root. If you do, virtualenv folders won't
have write permissions, so the tracker won't be able to write to sqlite
database.



Setting up a new instance of the system
=================================

Copy config.private.json.example to config.private.json.

```bash
cd ..
cp config.private.json.example config.private.json
vi config.private.json

```

You will then need to update the following files;

* streaming-system/config.private.json
  * Update the default object with the event details (where it says timvideos you will need to add your events id).
  * The parent object should have a child object for each room with the room_id matching the event feeds (used by eventfeed2internal.py) room_ids
* streaming-system/website/Makefile#L53
  * You may need to update the name of eventfeed2internal.py if you are creating a new parser.
* streaming-system/website/frontend/eventfeed2internal.py
  * This should generate a output that resembles https://gist.github.com/lukejohnosmahi/7938504
* streaming-system/website/frontend/static/logos/*.png
  * Remove any old logos and add the events logo (158x217 is a known to work dimension).
* streaming-system/website/frontend/static/img/favicon.ico
  * Update the favicon.ico with your events logo.



Production Deployment
=====================

 *  To account for differences between the dev and prod infrastructure a
    config-private.json can be provided at the base level directory.

 *  The deployment uses one user to deploy the code, and another user to
    run the code:

        tim@website:~$ grep website /etc/passwd /etc/group
        /etc/passwd:website:x:100:100::/home/website:/bin/bash
        /etc/passwd:website-run:x:101:101::/home/website-run:/bin/false
        /etc/group:website:x:101:tim
        /etc/group:website-run:x:105:website,tim

 *  Usually, the run user should only need read access to the files you've
    checked out. If there are specific files or directories that the run user
    needs to write to, simply use ``chgrp website-run $FILE; chmod g+w $FILE``
    to make them accessible to both the deploy and run users. If this needs to
    be persisted across deployments, you may have to take care of this in your
    deploy script.

 *  To do the deployment, I use the ``setup.sh`` script in conf directory. It
    takes a copy of the current code in ``~website/timvideos`` and puts it in
    ``~website/$VERSION-$DATE-$TIME`` directory and then links
    ``~website/current`` to that.

    This makes it relatively easy to revert to an earlier version of the code.

 *  The script will ask for a production settings.py to be created using
    non-sqlite details.  Populate this with a real DB, such as PostgreSQL.

 *  On a new installation, you will need to initialise the database (this is
    not done by setup.sh as it can be used for upgrades, too).  You can do this
    by running ```make initdb```.

 *  On an existing installation you may need to migrate any schema changes.
    You can do this by running ```bin/python manage.py migrate```.

 *  The app runs inside [Green Unicorn][], and is started by
    [upstart][]. Take a look at conf/init.conf

 *  The app uses [nginx][] as a frontend, and to serve static files. Only a few
    changes from the default config are needed to accomplish this.

    Take a look at conf/nginx.conf (this needs to be modified).

  [deploy key]: http://help.github.com/deploy-keys/
  [Green Unicorn]: http://gunicorn.org/
  [upstart]: http://upstart.ubuntu.com/
  [nginx]: http://nginx.org/en/ "nginx"
