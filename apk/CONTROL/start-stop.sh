#!/bin/sh
### BEGIN INIT INFO
# Provides:          tailscaled
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       tailscaled
### END INIT INFO

DAEMON=tailscaled
TS_STATE_DIR=/home/tailscaled
DAEMONOPTS="--state=$TS_STATE_DIR/tailscaled.state --port 41641"
RUNAS=root

PIDFILE=/var/run/tailscaled.pid
LOGFILE=/var/log/tailscaled.log

start() {
  if [ -f /var/run/$PIDNAME ]; then
    echo 'Service already running' >&2
    return 1
  fi

  mkdir -p $TS_STATE_DIR
  echo 'Starting service…' >&2
  local CMD="$DAEMON $DAEMONOPTS &> \"$LOGFILE\" & echo \$!"
  su -c "$CMD" $RUNAS > "$PIDFILE"
  su -c "tailscale status --listen 0.0.0.0:8384 --web &" $RUNAS
  su -c "tailscale up" $RUNAS
  echo 'Service started' >&2
}

stop() {
  if [ ! -f "$PIDFILE" ]; then
    echo 'Service not running' >&2
    return 1
  fi
  echo 'Stopping service…' >&2
  kill -15 $(cat "$PIDFILE") && rm -f "$PIDFILE"
  echo 'Service stopped' >&2
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
esac
