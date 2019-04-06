#!/bin/sh
if [ "$#" -eq 0 ];
then
REPLACE_OS_VARS=true /opt/app/bin/toksomanio foreground
fi
exec "$@"
