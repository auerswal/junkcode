#! /bin/sh

# capture.sh - capture one minute of traffic on a given interface.
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

CF='capture.pcap'
DURATION="1m"
IF="$1"

test -z "$1" && { echo usage: $0 INTERFACE; exit 1; }

rm -fv "$CF"
# XXX "tcpdump -G60 -W1" does not stop if interface down
# XXX tcpdump needs duration in seconds, just as POSIX sleep
# tcpdump -i "$IF" -G"$DURATION" -W1 -w "$CF" -v
tcpdump -w "$CF" -i "$IF" -v &
DUMPPID=$!
sleep "$DURATION"
kill "$DUMPPID"
wait
