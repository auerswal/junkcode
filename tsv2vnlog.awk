#! /usr/bin/awk -f

# vnlog2tsv.awk - convert GNU datamash TSV output to vnlog format
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

# The "vnlog" format maintained by Dima Kogan is intended for use with
# both existing Unix tools and specialized vnlog-aware programs.  It is
# described as "trivially simple" on <https://github.com/dkogan/vnlog>:
#
# - A whitespace-separated table of ASCII human-readable text
# - Lines beginning with # are comments
# - The first line that begins with a single # (not ## or #!) is a
#   legend, naming each column. This is required, and the field names
#   that appear here are referenced by all the tools.
# - Empty fields reported as -
#
# I have opened an issue to ask for clarification of some corner cases:
# <https://github.com/dkogan/vnlog/issues/6>
# Both tsv2vnlog.awk and vnlog2tsv.awk script are based on my assumptions.
#
# Emails sent to the bug-datamash@gnu.org mailing list suggest that
# in-line comments are part of the format in addition to comment lines.
#
# Handling of blank lines is not specified.
#
# I assume that legend fields must not be empty, i.e., using "-" to
# denote an empty field may be used for data lines only.  This script
# does not enforce or even check this.  It always uses "-" to denote
# an empty field.
#
# GNU datamash does not create vnlog compatible output.  In order to
# create the vnlog "legend", GNU datamash needs to write a header line.
# With the option -H, --headers, GNU datamash both reads and writes a
# header line.
#
# This script assumes that the first line is this header line and
# converts it into the vnlog "legend."
#
# To avoid ambiguities, a single space is used between fields in the
# vnlog conforming format created by this script.

# Change first line (the header) into a vnlog legend.  This just
# changes the contents of the first field of the first line of the
# TSV format data.  Further transformations from TSV to vnlog, i.e.,
# replacing each Tab with a Space and replacing empty fields with a
# Hyphen is done afterwards together with vnlog data line transformation.
NR == 1 { sub(/^/, "# ") }

# Convert line format from TSV to vnlog (every line including the first).
{
    sub(/^\t/, "-\t")          # possibly empty first field
    sub(/\t$/, "\t-")          # possibly empty last field
    while ($0 ~ /\t\t/) {
        gsub(/\t\t/, "\t-\t")  # possibly empty inner fields
    }

    # Replacing Tab characters with Space character is not required, but
    # I prefer it this way.
    gsub(/\t/, " ")            # use space instead of tab between fields

    print                      # emit vnlog format (legend or data) line
}
