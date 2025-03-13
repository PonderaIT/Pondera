#!/bin/bash
set -e

# Start PostgreSQL service
service postgresql start

# Initialize database if needed
if ! psql -U postgres -lqt | cut -d \| -f 1 | grep -qw pondera; then
    psql -U postgres -c "CREATE DATABASE pondera;"
    psql -U postgres -c "CREATE USER pondera WITH ENCRYPTED PASSWORD 'pondera';"
    psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE pondera TO pondera;"
fi

# Start backend in background
echo "Starting Rust backend..."
cd /app/backend
cargo run &

# Start frontend
echo "Starting Next.js frontend..."
cd /app/frontend
npm run dev