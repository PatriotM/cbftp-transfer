#!/bin/bash

# Parameter aus Aufruf
name="$1"
src_path="$2"
site="$3"

# POST-Request mit curl, Site verwenden, Ausgabe unterdrücken
curl -s -k -u ":bestpass" -X POST https://localhost:55477/transferjobs -d "{
  \"src_site\": \"$site\",
  \"src_path\": \"$src_path\",
  \"dst_site\": \"TARGET\",
  \"dst_path\": \"/TARGETPATH\",
  \"name\": \"$name\"
}" >/dev/null 2>&1
