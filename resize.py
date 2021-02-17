# Resize ExtremeXOS (EXOS) CLI to current remote terminal dimensions.

# Copyright (C) 2016 Erik Auerswald <auerswal@unix-ag.uni-kl.de>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# -----------------------------------------------------------------------------
# source for code inside terminal_size() function taken from a Stack
# Overflow answer by "pascal" and modified by "mic_e":
# http://stackoverflow.com/questions/566746/how-to-get-console-window-width-in-python/3010495#3010495
# (short link: https://stackoverflow.com/a/3010495)
# answer is from 2010, thus licensed under CC BY-SA 2.5 by Stack Exchange Inc.
def terminal_size():
    import fcntl, termios, struct
    h, w, hp, wp = struct.unpack('HHHH',
        fcntl.ioctl(1, termios.TIOCGWINSZ,
        struct.pack('HHHH', 0, 0, 0, 0)))
    return w, h
# -----------------------------------------------------------------------------

# this only works in remote sessions (SSH, Telnet), not via serial console
columns, lines = terminal_size()

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

# the exsh module is available on ExtremeXOS switches that provide Python
import exsh
exsh.clicmd("configure cli columns {0}".format(columns))
exsh.clicmd("configure cli lines {0}".format(lines))
