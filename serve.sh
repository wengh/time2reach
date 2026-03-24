#!/usr/bin/env bash
# 1-click local dev server: Rust backend (port 3030) + Vite frontend (port 5173)
set -euo pipefail

cd "$(dirname "$0")"

# --- Prerequisites check ---
if ! command -v pkg-config >/dev/null 2>&1 || ! pkg-config --exists gdal 2>/dev/null; then
    echo "ERROR: GDAL development headers not found."
    echo "Install with: sudo apt-get install -y libgdal-dev"
    exit 1
fi

if ! command -v uv >/dev/null 2>&1; then
    echo "ERROR: uv not found. Install with: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

if ! command -v cargo >/dev/null 2>&1; then
    echo "ERROR: cargo not found. Install Rust from https://rustup.rs"
    exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
    echo "ERROR: npm not found. Install Node.js from https://nodejs.org"
    exit 1
fi

# Install Python deps
uv sync

# Install frontend deps if needed
if [ ! -d web/node_modules ]; then
    echo "Installing frontend dependencies..."
    npm install --prefix web
fi

backend_pid=""
frontend_pid=""

cleanup() {
    echo ""
    echo "Shutting down..."
    if [ -n "$backend_pid" ]; then
        kill "$backend_pid" 2>/dev/null || true
    fi
    if [ -n "$frontend_pid" ]; then
        kill "$frontend_pid" 2>/dev/null || true
    fi
}
trap cleanup EXIT INT TERM

# Start Rust backend (dev mode: no GTFS loaded, HTTP only, port 3030)
cargo run &
backend_pid=$!

# Start Vite dev server (points to localhost:3030)
VITE_LOCAL=true npm run dev --prefix web &
frontend_pid=$!

wait
