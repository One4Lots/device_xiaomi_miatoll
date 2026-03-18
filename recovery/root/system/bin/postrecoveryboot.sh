#!/system/bin/sh
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2019-2026 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
#
# TODO: this kludge is needed to prevent issues with mounting
# system and vendor in some zip installers and in the gui
#

# requires bash
set_read_write_partitions() {
  local F=$(getprop "ro.orangefox.fastbootd");
  [ "$F" = "1" ] && return; # don't run this in fastbootd mode

  local Parts="system system_ext vendor product";
  for i in $Parts
  do
     echo "I:OrangeFox: setting $i to read/write" >> /tmp/recovery.log;
     blockdev --setrw /dev/block/mapper/$i;
  done
}

# prune historic logs
prune_historic_logs() {
local FOX_HOME=$(getprop "ro.orangefox.home");
local FOX_SETTINGS=$(getprop "ro.orangefox.settings");
local days="$1"; # number of days before we start pruning historic logs

	[ -z "$FOX_HOME" ] && FOX_HOME=/sdcard/Fox; # default
	[ -z "$FOX_SETTINGS" ] && FOX_SETTINGS=/sdcard/Fox; # default
	[ -z "$days" ] && days=14; # default
	local D="/sdcard/Fox/logs"; # default
	local D1=$FOX_HOME/logs;
	local D2=$FOX_SETTINGS/logs;
	if [ -d $D1 ]; then # home dir
		D=$D1;
	elif [ -d $D2 ]; then # settings dir
		D=$D2;
	fi

	# look only for the historic log zip files
	find "$D" -name "recovery*.zip" -maxdepth 1 -type f -mtime +$days -print -delete;
}

# ---
set_read_write_partitions;

prune_historic_logs "7";

exit 0;
#
