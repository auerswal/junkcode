# Resize ExtremeXOS (EXOS) CLI to current remote terminal dimensions.
#
# Copyright (C) 2021 Erik Auerswald <auerswal@unix-ag.uni-kl.de>
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
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# This method works via serial console, but only if the terminal (emulator)
# supports it and has it enabled.  GNOME Terminal supports it by default,
# XTerm needs enabling of the "Allow Window Ops" configuration option.

import os
import signal
import time

# send a command to the connected terminal(s)
fd = os.open('/dev/tty', os.O_WRONLY)
os.write(fd, b"\033[18t")
os.close(fd)

# overwrite echoed terminal answer(s)
time.sleep(0.15)
print '\rpress ENTER or CTRL-D to continue...'

# Python needs to be kicked to read the data, the script will block
# until the user does something useful...

# read the first arriving answer, or time out
signal.alarm(15)
reply_list = []
fd = os.open('/dev/tty', os.O_RDONLY)
try:
    c = os.read(fd, 1)
    while c != 't':
        reply_list.append(c)
        c = os.read(fd, 1)
except:
    print 'no terminal size information received before timeout'
    exit()

# read and discard whatever was sent after the first answer
fd = os.open('/dev/tty', os.O_RDONLY | os.O_NONBLOCK)
try:
    while os.read(fd, 1):
        pass
except:
    pass

# try to parse the reply
reply = ''.join(reply_list)
parts = reply.split(';')
try:
    if len(parts) >= 3:
        lines = int(parts[1])
        columns = int(parts[2])
    else:
        lines, columns = 24, 80
except:
    lines, columns = 24, 80

# columns must be in the range [80, 256]
if columns < 80:
    columns = 80
elif columns > 256:
    columns = 256

# lines must be in the range [24, 128]
if lines < 24:
    lines = 24
elif lines > 128:
    lines = 128

# tell the user what we are going to do
print 'setting terminal size to {0}x{1}'.format(columns, lines)

# the exsh module is available on ExtremeXOS switches that provide Python
import exsh
exsh.clicmd("configure cli columns {0}".format(columns))
exsh.clicmd("configure cli lines {0}".format(lines))
