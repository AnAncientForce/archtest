#!/bin/bash
# @AnAncientForce >> HP

waydroid prop set persist.waydroid.width ""
waydroid prop set persist.waydroid.height ""
waydroid session stop
echo "About to launch full ui... (3 secs waiting)"
sleep 3
waydroid show-full-ui &
