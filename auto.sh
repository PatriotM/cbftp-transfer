#!/bin/bash

while true; do
  echo "Start"
  seconds=7200  # 2 Stunden in Sekunden
  while [ $seconds -gt 0 ]; do
    echo -ne "Verbleibende Zeit: $((seconds / 3600))h $(((seconds % 3600) / 60))m $((seconds % 60))s \r"
    sleep 1
    ((seconds--))
  done
  echo -e "\nFertig! Starte 500..."
  ./fetch_and_prepare.sh 500  # Führt fetch_and_prepare.sh mit Argument 500 aus
  echo "ausgeführt. Nächster Durchlauf startet..."
done
