#!/system/bin/sh
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2026 The OrangeFox Recovery Project
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
DEBUG=0;
[ "$DEBUG" = "1" ] && set -o xtrace;

LOGMSG() {
	echo "I:$*" >> /tmp/recovery.log;
}

fix_sdcard_folders() {
local D=/sdcard/Fox; # /sdcard/Fox folder
	if [ -d $D ]; then
		LOGMSG "Correcting SELinux context and ownership of the $D folder...";
		chown -R media_rw:media_rw $D;
		chcon -R u:object_r:media_rw_data_file:s0 $D;
	fi
	sync;
}

# ---
fix_sdcard_folders;
exit 0;
#
