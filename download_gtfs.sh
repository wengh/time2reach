#!/usr/bin/env bash
# Downloads GTFS feeds for all configured cities into city-gtfs/
set -euo pipefail

mkdir -p city-gtfs/chicago

tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

echo "Downloading CTA (Chicago) GTFS..."
curl -fL "https://www.transitchicago.com/downloads/sch_data/google_transit.zip" \
    -o "$tmpfile"
unzip -o "$tmpfile" -d city-gtfs/chicago
echo "CTA GTFS saved to city-gtfs/chicago/"
