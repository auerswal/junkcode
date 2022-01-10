#! /usr/bin/gawk -f

# csv2tsv.gawk - convert a subset of CSV files to unquoted TSV format
# Copyright (C) 2022  Erik Auerswald <auerswal@unix-ag.uni-kl.de>
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

# The csv2tsv.gawk script provides a partial solution to the problems
# of using GNU Datamash with some bank statements from a German bank as
# described on the bug-datamash mailing list:
# https://lists.gnu.org/archive/html/bug-datamash/2022-01/msg00000.html
#
# This script is not a complete CSV implementation, but should work
# for bank statement CSV files similar to those shown in the mailing
# list post.
#
# For correct operation, the CSV file must fulfill the following
# requirements:
#  * Field delimiter is a semicolon (;).
#  * Empty fields are enclosed in double quotes.
#  * Fields contain neither Newline nor Tabulator characters.
#
# The output of this script uses ASCII Tabulator as field delimiter and
# should thus be usable as input for GNU Datamash.
#
# The number format shown in the mailing list post conforms to German
# locale settings.  Thus one can apply those for the GNU Datamash
# invocation (e.g., env LC_NUMERIC=de_DE.UTF-8 datamash ...).
#
# This script relies on the GNU Awk "FPAT" feature and is thus not
# portable to other Awk implementations:
# https://www.gnu.org/software/gawk/manual/html_node/Splitting-By-Content.html
#
# In my tests with GNU Awk 4.1.4, API: 1.1 (GNU MPFR 4.0.1, GNU MP
# 6.1.2) as included in the Ubuntu 18.04.6 LTS GNU/Linux distribution,
# empty fields in CSV files were skipped, unless the empty fields were
# enclosed in double quotes.  This may or may not be a bug, since the
# FPAT documentation currently (2022-01-10) states that empty fields
# should be supported.  Thus I have used an FPAT value that does not
# allow unquoted empty fields.

BEGIN {
  FPAT = "([^;]+|\"([^\"]|\"\")*\")"
  OFS = "\t"
}

{
  for (i=1; i<=NF; i++) {
    if(substr($i,1,1) == "\"") {
      len = length($i)
      $i = substr($i, 2, len-2)
    }
    gsub(/\"\"/, "\"", $i)
    if (i>1) {
      printf "%s", OFS
    }
    printf "%s", $i
  }
  printf "%s", ORS
}
