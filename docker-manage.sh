#!/bin/bash

# Docker Management Script for Memory Optimization
# Usage: ./docker-manage.sh [dev|full|prod|stop|clean|stats]

set -e

# Function to clean up unused Docker resources
cleanup() {
    echo "Cleaning up unused Docker resources..."
    docker system prune -f
    docker builder prune -f
}

# Function to build with cache
build_with_cache() {
    echo "Building services with cache..."
    docker-compose build --parallel --build-arg BUILDKIT_INLINE_CACHE=1
}

# Function to build without cache
build_fresh() {
    echo "Building services without cache..."
    docker-compose build --no-cache --parallel
}

# Function to start services
start() {
    echo "Starting services..."
    docker-compose up -d
}

# Function to stop services
stop() {
    echo "Stopping services..."
    docker-compose down
}

# Main script
case "$1" in
    "dev")
        echo "🚀 Starting development environment (minimal memory usage)..."
        docker-compose -f docker-compose.dev.yml up -d
        echo "✅ Development environment started!"
        echo "📊 Services running: RabbitMQ, Redis, MySQL"
        echo "💡 Run your applications locally with: npm run start:dev"
        ;;
    "full")
        echo "🚀 Starting full development stack..."
        docker-compose up -d
        echo "✅ Full development stack started!"
        echo "📊 All services running with memory limits"
        ;;
    "prod")
        echo "🚀 Starting production environment..."
        docker-compose -f docker-compose.prod.yml up -d
        echo "✅ Production environment started!"
        echo "📊 All services + monitoring stack running"
        ;;
    "stop")
        echo "🛑 Stopping all containers..."
        docker-compose down
        docker-compose -f docker-compose.dev.yml down
        docker-compose -f docker-compose.prod.yml down
        echo "✅ All containers stopped!"
        ;;
    "clean")
        echo "🧹 Cleaning up Docker resources..."
        docker system prune -f
        docker volume prune -f
        echo "✅ Cleanup completed!"
        ;;
    "stats")
        echo "📊 Container Memory Usage:"
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
        ;;
    "rebuild")
        echo "🔨 Rebuilding Docker images..."
        docker-compose build --no-cache
        docker-compose -f docker-compose.prod.yml build --no-cache
        echo "✅ Images rebuilt!"
        ;;
    "logs")
        echo "📋 Container logs:"
        docker-compose logs --tail=50
        ;;
    "build")
        build_with_cache
        ;;
    "build-fresh")
        build_fresh
        ;;
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    "cleanup")
        cleanup
        ;;
    "restart")
        stop
        start
        ;;
    *)
        echo "❌ Usage: $0 [dev|full|prod|stop|clean|stats|rebuild|logs|build|build-fresh|start|stop|cleanup|restart]"
        echo ""
        echo "Commands:"
        echo "  dev     - Start minimal development environment (~1GB RAM)"
        echo "  full    - Start full development stack (~4.5GB RAM)"
        echo "  prod    - Start production environment with monitoring (~3.7GB RAM)"
        echo "  stop    - Stop all containers"
        echo "  clean   - Clean up Docker resources"
        echo "  stats   - Show memory usage"
        echo "  rebuild - Rebuild all images"
        echo "  logs    - Show container logs"
        echo "  build   - Build images with cache"
        echo "  build-fresh - Build images without cache"
        echo "  start   - Start all services"
        echo "  stop    - Stop all services"
        echo "  cleanup - Clean up unused Docker resources"
        echo "  restart - Stop and start all services"
        echo ""
        echo "Memory Usage Guide:"
        echo "  - dev:   RabbitMQ (256MB) + Redis (256MB) + MySQL (512MB) = ~1GB"
        echo "  - full:  All services with limits = ~4.5GB"
        echo "  - prod:  Optimized production stack = ~3.7GB"
        exit 1
        ;;
esac 