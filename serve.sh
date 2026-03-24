#!/usr/bin/env bash
# 1-click local dev server: Rust backend (port 3030) + Vite frontend (port 5173)
set -euo pipefail

cd "$(dirname "$0")"

# --- Prerequisites check ---
if ! pkg-config --exists gdal 2>/dev/null; then
    echo "ERROR: GDAL development headers not found."
    echo "Install with: sudo apt-get install -y libgdal-dev"
    exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
    echo "ERROR: npm not found. Install Node.js (https://nodejs.org)."
    exit 1
fi

# Install Python deps
uv sync

# Install frontend deps if needed
if [ ! -d web/node_modules ]; then
    echo "Installing frontend dependencies..."
    npm install --prefix web
fi

cleanup() {
    echo ""
    echo "Shutting down..."
    kill 0
}
trap cleanup EXIT INT TERM

# Start Rust backend (dev mode: no GTFS loaded, HTTP only, port 3030)
cargo run &

# Start Vite dev server (points to localhost:3030)
VITE_LOCAL=true npm run dev --prefix web &

wait
