#! /bin/bash

# exos_ssh_key_fingerprint.sh - compute fingerprint for ExtremeXOS SSH key.
# Copyright (C) 2018  Erik Auerswald <auerswal@unix-ag.uni-kl.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -u

test "$#" -eq 1 ||
  { echo 'Usage: exos_ssh_key_fingerprint.sh FILENAME'; exit 1; }

umask 0077
TDIR="$(mktemp -d "exos_ssh_key_fingerprint.$$.XXXXXXXXXX")" ||
  { echo 'ERROR: could not create temporary directory'; exit 1; }
trap "rm -rf \"$TDIR\"" 0 1 2 3 15

tr -dc '[:xdigit:]' < "$1" | xxd -p -r > "$TDIR/key.ascii"
fgrep -i encrypted "$TDIR/key.ascii" >/dev/null 2>&1 &&
  { echo 'ERROR: SSH key is encrypted'; exit 1; }
chmod 600 "$TDIR/key.ascii"
ssh-keygen -y -f "$TDIR/key.ascii" > "$TDIR/pubkey"
ssh-keygen -l -f "$TDIR/pubkey" | cut -d' ' -f2
