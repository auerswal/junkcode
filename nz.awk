#! /usr/bin/awk -f

# nz.awk - filter out lines in which all decimal numbers are zero
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

# print line if it contains
# 1) no 0
# 2) one zero followed by a non-zero digit
# 3) one non-zero digit followed by a zero
/^([^0]*|(.*(0.*[1-9]|[1-9].*0).*))$/
