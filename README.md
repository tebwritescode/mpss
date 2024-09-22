##mpss##
MPSS (Mount Point Service Sync) dynamically controls start/stop of services (plexmediaserver, tdarr_node, Tdarr_Uptime, emby-server) based on presence or absence of "MOUNT_POINT_ALIVE" file on a network share. It logs actions to /var/log/mpss.log and trims the log to 200 lines.
