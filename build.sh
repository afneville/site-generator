#!/bin/sh

live-server --no-browser out &
watch-directory.sh src make &
watch-directory.sh res make &
