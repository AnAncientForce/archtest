#!/bin/bash
# @AnAncientForce >> HP

if pgrep -x "wf-recorder" >/dev/null; then
    # stop recording if already recording
    pkill -SIGINT wf-recorder
else
    # record if not already recording
    wf-recorder --audio --file=/home/$(whoami)/Videos/$(date +"%Y%m%d-%H%M%S").mp4
fi
