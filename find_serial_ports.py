#! /usr/bin/env python3

# find_serial_ports.py - enumerate serial ports on Linux
# Copyright (C) 2020  Erik Auerswald <auerswal@unix-ag.uni-kl.de>
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

import glob
import serial

for device in glob.glob('/dev/ttyS*') + glob.glob('/dev/ttyUSB*'):
    try:
        ser = serial.Serial(device)
    except:
        continue
    ser.close()
    print(device)
