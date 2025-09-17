# Multi-stage build for NebulaGraph deployment on Railway
FROM vesoft/nebula-graphd:latest

# Set working directory
WORKDIR /usr/local/nebula

# Copy configuration files
COPY config/nebula.conf /usr/local/nebula/etc/
COPY config/graphd.conf /usr/local/nebula/etc/

# Create necessary directories
RUN mkdir -p /data /logs

# Expose ports
EXPOSE 9669 19669

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:19669/status || exit 1

# Start NebulaGraph GraphD
CMD ["/usr/local/nebula/bin/nebula-graphd", "--flagfile=/usr/local/nebula/etc/graphd.conf"]
