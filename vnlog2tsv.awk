#! /usr/bin/awk -f

# vnlog2tsv.awk - convert vnlog data for use with GNU datamash
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
# A comment in the GitHub issue mentioned above seems to indicate that
# this assumption only holds for data lines, not the legend (header line).
#
# I assume that both leading and trailing whitespace shall be ignored,
# because field splitting in Awk works this way.
#
# Handling of blank lines is not specified.  For this script I assume
# that they are intended to be ignored similar to comment lines.
#
# I had assumed that legend fields must not be empty, i.e., using '-'
# to denote an empty field may be used for data lines only.  This
# script does not enforce or even check this.
#
# I had also assumed that every non-comment input line could have
# trailing comments.
#
# It seems as if the two assumptions above have been wrong, i.e, they
# do not hold for the legend (header line).  Thus I have adjusted this
# script to keep all fields from the legend, i.e., to just remove the
# single leading '#' character including optional surrounding whitespace.
#
# In order to use vnlog data as input to GNU datamash, it needs to be
# converted to a format understood by GNU datamash.  GNU datamash
# supports a simple TSV format where each TAB character separates two
# data fields.  By default, this format does not allow for comments.
# By default, this format does not use a header (or legend).
#
# GNU datamash supports comment lines via the option --skip-comments,
# but it does not support in-line comments.  Contrary to vnlog, GNU
# datamash also treats lines starting with a semicolon (';') as
# comments.  GNU datamash does not distinguish between comment lines
# before the "legend" or "header line" and after, either.  Thus the
# comment handling of GNU datamash is incompatible with vnlog.
# Therefore this script removes all comments from the vnlog input.
#
# GNU datamash supports reading and writing a header line via the option
# --headers.  This header is syntactically identical to a data line.
# It is just the first input line.  In vnlog, the header or "legend" is
# syntactically a comment line.  Therefore this script extracts the
# "legend" from the vnlog data and writes it without comment character
# syntactically as a data line.
#
# To correctly accept vnlog data converted by this script, GNU datamash
# needs to be provided with an option to recognize a header line in the
# input data.
#
# If GNU datamash output is intended to be converted to vnlog format,
# GNU datamash needs to be provided with an option to output a header
# line.
#
# With the option -H, --headers, GNU datamash both reads and writes a
# header line.

# Lines starting with optional whitespace followed by "##" or "#!" are
# always comments in vnlog.
/^[[:space:]]*#[#!]/ { next }               # skip comment line

# Lines starting with optional whitespace followed by "#" are comments,
# but only after the vnlog "legend".
/^[[:space:]]*#/ && have_legend { next }    # skip comment line

# I would expect blank lines to be ignored, but the specification does
# not mention them.
/^[[:space:]]*$/ { next }                   # skip blank lines

# The first line starting with optional whitespace followed by "#" is
# the vnlog "legend" (similar in function to a header line in GNU datamash).
# The legend has no trailing comments and no empty fields.
/^[[:space:]]*#/ && !have_legend {
    have_legend = 1
    sub(/^[[:space:]]*#[[:space:]]*/, "")   # adjust legend (header) format
    gsub(/[[:space:]]+/, "\t")              # convert field separators
    print                                   # emit modified header line
    next                                    # stop processing this line
}

# Other lines are data lines; syntactically, for GNU datamash, even the
# "legend" is a data line:
# - data lines can have in-line comments starting with "#" and extending
#   to the end of the line;
# - vnlog uses whitespace (one or more space or tabulator characters) as
#   field separator;
# - vnlog uses "-" to represent an empty field;
# - trailing whitespace is ignored.
{
    sub(/^[[:space:]]+/, "")                # remove leading whitespace
    sub(/[[:space:]]*#.*$/, "")             # remove in-line comments
    sub(/[[:space:]]+$/, "")                # remove trailing whitespace
    gsub(/[[:space:]]+/, "\t")              # convert field separators
    while ($0 ~ /\t-\t/) {
        gsub(/\t-\t/, "\t\t")               # convert empty inner fields
    }
    sub(/^-\t/, "\t")                       # convert empty first field
    sub(/\t-$/, "\t")                       # convert empty last field
    print                                   # emit modified data line
}
