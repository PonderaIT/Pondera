# Development stage
FROM rust:1.85-slim AS dev

# Install PostgreSQL client for database interactions
RUN apt-get update && apt-get install -y \
    postgresql-client \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Initialize new Rust project
RUN cargo init

# Set environment variables
ENV RUST_LOG=debug

# Expose backend port
EXPOSE 8000

# Start command for development
CMD ["cargo", "run"]

# Production build stage
FROM rust:1.85-slim AS builder

WORKDIR /app
COPY . .
RUN cargo build --release

# Final production stage
FROM debian:bookworm-slim AS prod

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    ca-certificates \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Copy the built binary
COPY --from=builder /app/target/release/pondera-backend /usr/local/bin/

# Environment variables
ENV RUST_LOG=info

# Expose backend port
EXPOSE 8000

# Start command for production
CMD ["pondera-backend"]