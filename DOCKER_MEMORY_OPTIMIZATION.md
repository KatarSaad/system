# Docker Memory Optimization Guide

## Overview

This guide explains the memory optimizations made to reduce RAM usage in your Docker setup.

## Memory Usage Before vs After

### Before Optimization:

- **Total estimated RAM usage**: ~4-6GB
- No memory limits on containers
- Heavy monitoring stack (Prometheus, Grafana, Jaeger) always running
- Development mode with file watching for all services
- Inefficient Docker images

### After Optimization:

- **Development mode**: ~1.5-2GB total RAM
- **Production mode**: ~2.5-3GB total RAM
- Strict memory limits on all containers
- Optional monitoring stack
- Optimized Docker images with multi-stage builds

## Key Optimizations Made

### 1. Memory Limits

All containers now have strict memory limits:

- **API Gateway**: 512MB limit, 256MB reservation
- **Auth Service**: 512MB limit, 256MB reservation
- **Logger Service**: 256MB limit, 128MB reservation
- **Starter App**: 1GB limit, 512MB reservation
- **RabbitMQ**: 256MB limit, 128MB reservation
- **Redis**: 256MB limit, 128MB reservation
- **MySQL**: 512MB limit, 256MB reservation

### 2. Node.js Memory Optimization

Added `NODE_OPTIONS=--max-old-space-size=XXX` to limit Node.js heap:

- **API Gateway**: 256MB
- **Auth Service**: 256MB
- **Logger Service**: 128MB
- **Starter App**: 512MB

### 3. Optimized Docker Images

- Multi-stage builds to reduce image size
- Alpine-based images for smaller footprint
- Non-root users for security
- Health checks for better container management

### 4. Service Separation

- **Development**: Only essential services (RabbitMQ, Redis, MySQL)
- **Production**: Full stack with monitoring

## Usage Instructions

### For Development (Low Memory Usage)

```bash
# Start only essential services
docker-compose -f docker-compose.dev.yml up -d

# Run your applications locally
npm run start:dev  # in each service directory
```

### For Full Development Stack

```bash
# Start all services with memory limits
docker-compose up -d

# Monitor memory usage
docker stats
```

### For Production

```bash
# Start production stack with monitoring
docker-compose -f docker-compose.prod.yml up -d

# Monitor memory usage
docker stats
```

## Memory Usage Breakdown

### Development Mode (docker-compose.dev.yml)

- **RabbitMQ**: 256MB
- **Redis**: 256MB
- **MySQL**: 512MB
- **Total**: ~1GB

### Full Development Stack

- **API Gateway**: 512MB
- **Auth Service**: 512MB
- **Logger Service**: 256MB
- **Starter App**: 1GB
- **RabbitMQ**: 256MB
- **Redis**: 256MB
- **MySQL**: 512MB
- **Other Services**: 1.5GB
- **Total**: ~4.5GB

### Production Stack

- **All Services**: ~2.5GB
- **Monitoring**: ~1.2GB
- **Total**: ~3.7GB

## Additional Tips

### 1. Monitor Memory Usage

```bash
# Check container memory usage
docker stats

# Check system memory
free -h

# Monitor specific container
docker stats api-gateway
```

### 2. Reduce Memory Further

If you need even less memory:

1. **Remove unused services** from docker-compose.yml
2. **Lower memory limits** in deploy.resources.limits
3. **Use production mode** instead of development
4. **Run services locally** instead of in containers

### 3. Optimize Node.js Applications

Add to your application's environment:

```bash
NODE_OPTIONS="--max-old-space-size=256 --optimize-for-size"
```

### 4. Database Optimization

```bash
# MySQL optimization
docker-compose exec mysql mysql -u root -p
# Set: innodb_buffer_pool_size = 256M

# Redis optimization
# Already configured with maxmemory 128mb
```

## Troubleshooting

### Container OOM (Out of Memory)

If containers are being killed due to memory limits:

1. **Increase memory limits** in docker-compose.yml
2. **Check for memory leaks** in your application
3. **Optimize application code**
4. **Use production mode** instead of development

### High Memory Usage

```bash
# Check which containers use most memory
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Restart containers to free memory
docker-compose restart

# Clean up unused resources
docker system prune -a
```

## Environment Variables for Memory Optimization

Add these to your `.env` files:

```bash
# Node.js memory optimization
NODE_OPTIONS=--max-old-space-size=256

# Docker memory limits
DOCKER_MEMORY_LIMIT=512m

# Development mode (disable heavy services)
DISABLE_MONITORING=true
```

## Performance Monitoring

### Enable Monitoring (Optional)

```bash
# Uncomment monitoring services in docker-compose.yml
# Or use production compose file
docker-compose -f docker-compose.prod.yml up -d
```

### Access Monitoring Tools

- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001
- **Jaeger**: http://localhost:16686
- **RabbitMQ Management**: http://localhost:15672

## Summary

These optimizations should reduce your Docker memory usage by 50-70% while maintaining full functionality. The key is using the right configuration for your needs:

- **Development**: Use `docker-compose.dev.yml` for minimal memory usage
- **Full Development**: Use `docker-compose.yml` with memory limits
- **Production**: Use `docker-compose.prod.yml` with monitoring

Remember to rebuild your Docker images after making changes:

```bash
docker-compose build --no-cache
```
