# Multi-stage build for NebulaGraph deployment on Railway
FROM vesoft/nebula-graphd:latest

# Install curl for health checks and copy binaries from other images
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy MetaD and StorageD binaries from their respective images
COPY --from=vesoft/nebula-metad:latest /usr/local/nebula/bin/nebula-metad /usr/local/nebula/bin/
COPY --from=vesoft/nebula-storaged:latest /usr/local/nebula/bin/nebula-storaged /usr/local/nebula/bin/

# Set working directory
WORKDIR /usr/local/nebula

# Copy configuration files
COPY config/nebula.conf /usr/local/nebula/etc/
COPY config/graphd.conf /usr/local/nebula/etc/
COPY config/metad.conf /usr/local/nebula/etc/
COPY config/storaged.conf /usr/local/nebula/etc/

# Copy startup script
COPY scripts/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Create necessary directories
RUN mkdir -p /data /logs

# Expose ports
EXPOSE 9669 19669 9559 9779

# Health check - check if GraphD is responding
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=5 \
  CMD curl -f http://localhost:19669/status || exit 1

# Start all NebulaGraph services
CMD ["/usr/local/bin/start.sh"]
