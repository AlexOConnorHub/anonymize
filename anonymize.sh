#!/usr/bin/env bash

# *---------------------------------------------------------------------------
#    SPDX-FileCopyrightText: Carlo Piana <kappa@piana.eu>
#
#    SPDX-License-Identifier: AGPL-3.0-or-later
# *---------------------------------------------------------------------------
#
#    ODT and DOCX anonymizer v.0.99
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
# *---------------------------------------------------------------------------

declare -a authors_array=()
an_filename=$(pwd)"/_anonymized_$1"
zipdir="/tmp/libreoffice"

mkdir $zipdir 2&> /dev/null
rm -rf ${zipdir:?}/*

if ! [ -f "$1" ] ; then
  exit 1
fi

unzip -oq "$1" -d $zipdir
mapfile -t authors_array < <(grep -hoP w:author=\"\(.\*\?\)\" $zipdir -R | sort | uniq | sed -E "s@w:author=\"(.*?)\"@\1@g")

for i in "${authors_array[@]}" ; do
  for f in $(find $zipdir -mindepth 2 -name '*.xml' ); do # get all xml only in subdirectory (not interested elsewhere)
    sed -i -E s@"(author=\")$i(\")"@"\1\2"@g $f # get author
    sed -i -E s@"(By>)$i(<)"@"\1\2"@g "$f" # get By
    sed -i -E s@"(initials=)$i(<)"@"\1\2"@g "$f" # get initials
    sed -i -E s@"(userId=)$i(<)"@"\1\2"@g "$f" # get userId
  done
done

cd "$zipdir" || exit 1  # in case cd fails

if [ -f "$an_filename" ] ; then #remove anonymized if previously created, to make room for clean zipfile
  rm "$an_filename"
fi

find . -print | zip "$an_filename" -@ 1>/dev/null
