#! /usr/bin/awk -f

# humanize_numbers.awk - make numbers more readable
# Copyright (C) 2022  Erik Auerswald <auerswal@unix-ag.uni-kl.de>

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

# This little program is inspired by a blog post from Chris Siebenmann:
# "Humanizing numbers in Python through a regexp substitution function"
# https://utcc.utoronto.ca/~cks/space/blog/python/RegexpFunctionSubstitutionWin
#
# While I immediately thought[0] of using "numfmt" from GNU Coreutils and
# "column" as found in "bsdmainutils" in Debian or Ubuntu, I am curious
# how an AWK implementation might look.
#
# The general idea of this program follows the blog post description of
# the Python program.
#
# As a significant difference between using "numfmt" and this AWK script
# or the Python program described by Chris Siebenmann, this AWK script and
# AFAIUI Chris Siebenmann's Python program detect numbers in the input,
# while "numfmt" needs to be told which input field(s) shall be processed.
#
# Example input data from the blog post processed with "numfmt" and
# "column":
#
#     $ numfmt --field=2 --to=iec --round=nearest <<EOF | column -t
#     > file 10361909248
#     > percpu 315360
#     > inactive_file 8666644480
#     > active_file 1695264768
#     > slab_reclaimable 194324760
#     > slab 194324760
#     > EOF
#     file              9,7G
#     percpu            308K
#     inactive_file     8,1G
#     active_file       1,6G
#     slab_reclaimable  185M
#     slab              185M
#
# Example input data from the blog post processed with this AWK script:
#
#     $ ./humanize_numbers.awk <<EOF | column -t
#     > file 10361909248
#     > percpu 315360
#     > inactive_file 8666644480
#     > active_file 1695264768
#     > slab_reclaimable 194324760
#     > slab 194324760
#     > EOF
#     file              9.7Gi
#     percpu            308.0Ki
#     inactive_file     8.1Gi
#     active_file       1.6Gi
#     slab_reclaimable  185.3Mi
#     slab              185.3Mi
#
# [0] The comment mentioning those programs is not from me, because I
#     read the blog post at a time when this comment already existed.
# https://utcc.utoronto.ca/~cks/space/blog/python/RegexpFunctionSubstitutionWin?showcomments#comments

BEGIN {
    CONVFMT = "%3.1f"
    unit = 1024
    one = unit
    num_orders = split("Ki Mi Gi Ti Pi", suffix)
    for (i = 1; i <= num_orders; i++) {
        units[i] = one
        one *= unit
    }
}

function humanize(number) {
    for (j = num_orders; j > 0; j--) {
        if (number > units[j]) {
            return number/units[j] suffix[j]
        }
    }
    return number
}

{
    for (i = 1; i <= NF; i++) {
        if ($i ~ /^[0-9]+$/) {
            $i = humanize($i)
        }
    }
    print
}
