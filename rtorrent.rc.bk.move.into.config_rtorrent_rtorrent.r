execute = {sh,-c,/usr/bin/php7 /usr/share/webapps/rutorrent/php/initplugins.php abc &}
execute.nothrow = rm,/run/php/.rtorrent.sock
network.scgi.open_local = /run/php/.rtorrent.sock
schedule = socket_chmod,0,0,"execute=chmod,0660,/run/php/.rtorrent.sock"
schedule = socket_chgrp,0,0,"execute=chgrp,abc,/run/php/.rtorrent.sock"
log.open_file = "rtorrent", /config/log/rtorrent/rtorrent.log
log.add_output = "info", "rtorrent"
min_peers = 40
max_peers = 1200
max_uploads = 15

#set max download and upload speed
download_rate = 1
upload_rate = 1

#Set watcher directories and tags
#schedule = watch_directory_1,5,5,"load.start=/downloads/watched/*.torrent"
schedule2 = watch_directory_1,5,5,"load.start=/downloads/watched/movies/*.torrent,d.custom1.set=movies"
schedule2 = watch_directory_2,5,5,"load.start=/downloads/watched/kidmovies/*torrent,d.custom1.set=kidmovies"
schedule2 = watch_directory_3,5,5,"load.start=/downloads/watched/private/*torrent,d.custom1.set=private"
schedule2 = watch_directory_4,5,5,"load.start=/downloads/watched/tv/*torrent,d.custom1.set=tv"

#Download directory and session
directory = /downloads/incoming
session = /config/rtorrent/rtorrent_sess

schedule = low_diskspace,5,60,close_low_diskspace=200M
# ip = 178.32.28.51
bind = 0.0.0.0
port_range = 51413-51413
check_hash = yes
encryption = allow_incoming,try_outgoing,enable_retry
dht = auto
dht_port = 6881
# network.http.ssl_verify_peer.set=0
# scgi_port = 0.0.0.0:5000
encoding_list = UTF-8
# system.umask.set = 022

#Rating. Execute, begining at hh:mm:ss every hh:mm:ss, something
schedule2 = throttle_up1,07:00:00,24:00:00,upload_rate=1
schedule2 = throttle_do1,07:00:00,24:00:00,download_rate=1
schedule2 = throttle_up2,22:00:00,24:00:00,upload_rate=0
schedule2 = throttle_do2,22:00:00,24:00:00,download_rate=0
#schedule2 = throttle_up3,09:10:00,24:00:00,upload_rate=1
#schedule2 = throttle_do3,09:10:00,24:00:00,download_rate=1

#Así se haría según la guía, pero a mi no me funciona bien. Voy a ejecutar un script propio que mueva los ficheros cuando acabe una descarga
method.insert = d.data_path, simple, "if=(d.is_multi_file), (cat,(d.directory),/), (cat,(d.directory),/,(d.name))"
#method.insert = d.move_to_complete, simple, "d.directory.set=$argument.1=; execute=mkdir,-p,$argument.1=; execute=mv,-u,$argument.0=,$argument.1=; d.save_full_session="
#method.set_key = event.download.finished,move_complete,"d.move_to_complete=$d.data_path=,$d.custom1="

method.set_key = event.download.finished,move_completed,"execute=sh,/downloads/scripts/downloaded.sh,$d.data_path=,$d.custom1=; d.save_full_session="
method.set_key = event.download.paused,move_paused,"execute=sh,/downloads/scripts/pruebas.sh,$d.data_path=,$d.custom1=; d.save_full_session="
method.set_key = event.download.resumed,move_resumed,"execute=sh,/downloads/scripts/pruebas.sh,$d.data_path=,$d.custom1=; d.save_full_session="

#Ratio groups. Action triggered if config is setted
# Min(%), Max(%), Upl(MB), Time(h), Action Triggered
# no,     no,     no,      no,      no
# yes,    no,     no,      no,      no
# no,     no,     yes,     no,      no
# yes,    no,     yes,     no,      yes
# no,     no,     no,      yes,     yes
# no,     yes,    no,      no,      yes
# Enable the default ratio group.
ratio.enable=

# Change the limits, the defaults should be sufficient.
ratio.min.set=100
ratio.max.set=200
ratio.upload.set=500M

# Changing the command triggered when the ratio is reached.
# (the default is "d.try_close= ; d.ignore_commands.set=1")
#method.set = group.seeding.ratio.command, "d.close= ; d.erase="
method.set = group.seeding.ratio.command, "d.close="


