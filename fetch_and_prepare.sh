#!/bin/bash

# Anzahl der Abfragen aus Argument, Standardwert 5000
max_entries="${1:-5000}"

# Liste der Sites mit Pfaden im Format SITE:PATH
sites="SITE1:/INCOMING/LATEST-UPLOADS/ SITE2:/latest-Uploads SITE3:/LATEST-UPLOADS/"

# Schleife über jede Site:Path Kombination
for entry in $sites; do
  # Site und Path trennen (getrennt durch :)
  site=$(echo "$entry" | cut -d':' -f1)
  path=$(echo "$entry" | cut -d':' -f2-)

  # GET-Request ausführen, Site und Path einsetzen, Ausgabe unterdrücken
  response=$(curl -s -k -u :bestpass -X GET "https://localhost:55479/path?site=$site&path=$path")

  # Prüfen, ob die Antwort leer ist
  if [ -z "$response" ] || [ "$response" = "[]" ]; then
    echo "Warnung: Keine Daten für Site $site mit Path $path erhalten" >&2
    continue
  fi

  # JSON mit jq parsen, nach last_modified absteigend sortieren, max. $max_entries Einträge
  entries=$(echo "$response" | jq -r --argjson max "$max_entries" 'sort_by(.last_modified) | reverse | .[0:$max] | .[] | .name + "\t" + .link_target')

  # Prüfen, ob Einträge vorhanden sind
  if [ -z "$entries" ]; then
    echo "Warnung: Keine Einträge für Site $site mit Path $path nach Parsen" >&2
    continue
  fi

  # Einträge verarbeiten
  echo "$entries" | while IFS=$'\t' read -r name link_target; do
    # link_target ohne den Namen bereinigen und den site-spezifischen Pfad entfernen
    src_path=$(echo "$link_target" | sed "s|$name$||" | sed "s|$path||")

    # Zweites Skript aufrufen, Site mit übergeben
    ./transfer_job.sh "$name" "$src_path" "$site" >/dev/null 2>&1
  done
done
