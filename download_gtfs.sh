#!/usr/bin/env bash
# Downloads GTFS feeds for all configured cities into city-gtfs/
set -euo pipefail

mkdir -p city-gtfs/chicago

echo "Downloading CTA (Chicago) GTFS..."
curl -L "https://www.transitchicago.com/downloads/sch_data/google_transit.zip" \
    -o /tmp/chicago_gtfs.zip
unzip -o /tmp/chicago_gtfs.zip -d city-gtfs/chicago
rm /tmp/chicago_gtfs.zip
echo "CTA GTFS saved to city-gtfs/chicago/"
