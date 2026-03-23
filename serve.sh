#!/usr/bin/env bash
# 1-click local dev server: Rust backend (port 3030) + Vite frontend (port 5173)
set -euo pipefail

cd "$(dirname "$0")"

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
