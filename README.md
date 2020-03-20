### Receta de docker
En esta receta de docker-compose tendremos 2 contenedores: plex y rtorrent. 
rtorrent es un cliente de torrent via linea de comandos.

### Accesos web
> plex: ip:32400/web
> rtorrent: ip:32500 -> por asemejarlo a plex

### Rtorrent
La instalación de rutorrent creará dentro de la carpeta de descargas (crearemos un volúmen) otras 3 subcarpetas: completed, incoming and watched
Watched es la carpeta que rtorrent está escuchando para iniciar las descargas, todo torrent que llegue ahí será descargado pero es necesario activarlo en la configuración. Para ello, abrir la carpeta ./config/rtorrent/rtorrent.rc y descomentar la línea
```
schedule = watch_directory_1,5,5,"load.start=/downloads/watched/*.torrent"
```
Tambien es necesario abrir el puerto 51413 en el router

### Rtorrent tiene un problema. La configuración
Estoy intentando hacer lo siguiente, tener 2 carpetas que "escuchen" los .torrent que inserto e iniciar directamente la descarga de los mismos. A su vez, cuando se descarguen completamente, quiero moverlos a una carpeta diferente.
Bien, lo primero lo tengo claro y se puede ver en el fichero config/rtorrent/rtorrent.rc; 
```
schedule = watch_directory_1,5,5,"load.start=/downloads/watched/*.torrent"
schedule2 = watch_directory_1,10,10,"load.start=/downloads/watched/movies/*.torrent,d.custom1.set=/downloads/completed/"
```
En la primera línea simplemente declaramos la carpeta de escucha y en la segunda, además, le indicamos un custom1 (un tag) a dicha carpeta. Posteriormente, este tag será la carpeta a donde queremos mover el fichero completado.
Pero no funciona, con unas carpetas sí, otras veces añade dicho tag como concatenación de la ruta /downloads/completed/EL_TAG_QUE_HEMOS_CREADO y otras veces siemplemente no funciona.
Según su web, se haría así:
```
method.insert = d.data_path, simple, "if=(d.is_multi_file), (cat,(d.directory),/), (cat,(d.directory),/,(d.name))"
method.insert = d.move_to_complete, simple, "d.directory.set=$argument.1=; execute=mkdir,-p,$argument.1=; execute=mv,-u,$argument.0=,$argument.1=; d.save_full_session="
method.set_key = event.download.finished,move_complete,"d.move_to_complete=$d.data_path=,$d.custom1="
```
Por esto, vamos a intentar montar el gestor de descargas de torrent con ***deluge***

### Deluge
#### Interfaz web
El acceso será mediante la url IP:8112
