#! /bin/sed -nrf

# nz.sed - filter out lines in which all decimal numbers are zero
# Copyright (C) 2016  Erik Auerswald <auerswal@unix-ag.uni-kl.de>
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

# The "nz" filter suppresses lines that contain decimal numbers, if
# all those numbers are zero. This can be useful if a list of error
# counters contains mostly zero values, but one is interested in the
# few non-zero cases.
# 
# The simple "nz" filter has no special cases, so that e.g. an
# interface name of "eth0" or "Ethernet0/0" would be filtered out
# as well.

# print line if
# 1) no 0 in the line
# 2) one zero followed by a non-zero digit
# 3) one non-zero digit followed by a zero
/^([^0]*|(.*(0.*[1-9]|[1-9].*0).*))$/p
