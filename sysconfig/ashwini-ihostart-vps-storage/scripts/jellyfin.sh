#!/bin/bash
JLLFINDIR="/opt/jellyfin/jellyfin"
FFMPEGDIR="/opt/jellyfin/jellyfin-ffmpeg"
JLLETCDIR="/home/banskt/local/etc/jellyfin"


${JLLFINDIR}/jellyfin \
 --datadir   ${JLLETCDIR}/data \
 --cachedir  ${JLLETCDIR}/cache \
 --configdir ${JLLETCDIR}/config \
 --logdir    ${JLLETCDIR}/log \
 --ffmpeg ${FFMPEGDIR}
