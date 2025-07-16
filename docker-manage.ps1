# Docker Management Script for Memory Optimization (PowerShell)
# Usage: .\docker-manage.ps1 [dev|full|prod|stop|clean|stats]

param(
    [Parameter(Position=0)]
    [string]$Command
)

switch ($Command) {
    "dev" {
        Write-Host "🚀 Starting development environment (minimal memory usage)..." -ForegroundColor Green
        docker-compose -f docker-compose.dev.yml up -d
        Write-Host "✅ Development environment started!" -ForegroundColor Green
        Write-Host "📊 Services running: RabbitMQ, Redis, MySQL" -ForegroundColor Cyan
        Write-Host "💡 Run your applications locally with: npm run start:dev" -ForegroundColor Yellow
    }
    "full" {
        Write-Host "🚀 Starting full development stack..." -ForegroundColor Green
        docker-compose up -d
        Write-Host "✅ Full development stack started!" -ForegroundColor Green
        Write-Host "📊 All services running with memory limits" -ForegroundColor Cyan
    }
    "prod" {
        Write-Host "🚀 Starting production environment..." -ForegroundColor Green
        docker-compose -f docker-compose.prod.yml up -d
        Write-Host "✅ Production environment started!" -ForegroundColor Green
        Write-Host "📊 All services + monitoring stack running" -ForegroundColor Cyan
    }
    "stop" {
        Write-Host "🛑 Stopping all containers..." -ForegroundColor Yellow
        docker-compose down
        docker-compose -f docker-compose.dev.yml down
        docker-compose -f docker-compose.prod.yml down
        Write-Host "✅ All containers stopped!" -ForegroundColor Green
    }
    "clean" {
        Write-Host "🧹 Cleaning up Docker resources..." -ForegroundColor Yellow
        docker system prune -f
        docker volume prune -f
        Write-Host "✅ Cleanup completed!" -ForegroundColor Green
    }
    "stats" {
        Write-Host "📊 Container Memory Usage:" -ForegroundColor Cyan
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
    }
    "rebuild" {
        Write-Host "🔨 Rebuilding Docker images..." -ForegroundColor Yellow
        docker-compose build --no-cache
        docker-compose -f docker-compose.prod.yml build --no-cache
        Write-Host "✅ Images rebuilt!" -ForegroundColor Green
    }
    "logs" {
        Write-Host "📋 Container logs:" -ForegroundColor Cyan
        docker-compose logs --tail=50
    }
    default {
        Write-Host "❌ Usage: .\docker-manage.ps1 [dev|full|prod|stop|clean|stats|rebuild|logs]" -ForegroundColor Red
        Write-Host ""
        Write-Host "Commands:" -ForegroundColor White
        Write-Host "  dev     - Start minimal development environment (~1GB RAM)" -ForegroundColor Cyan
        Write-Host "  full    - Start full development stack (~4.5GB RAM)" -ForegroundColor Cyan
        Write-Host "  prod    - Start production environment with monitoring (~3.7GB RAM)" -ForegroundColor Cyan
        Write-Host "  stop    - Stop all containers" -ForegroundColor Cyan
        Write-Host "  clean   - Clean up Docker resources" -ForegroundColor Cyan
        Write-Host "  stats   - Show memory usage" -ForegroundColor Cyan
        Write-Host "  rebuild - Rebuild all images" -ForegroundColor Cyan
        Write-Host "  logs    - Show container logs" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Memory Usage Guide:" -ForegroundColor White
        Write-Host "  - dev:   RabbitMQ (256MB) + Redis (256MB) + MySQL (512MB) = ~1GB" -ForegroundColor Yellow
        Write-Host "  - full:  All services with limits = ~4.5GB" -ForegroundColor Yellow
        Write-Host "  - prod:  Optimized production stack = ~3.7GB" -ForegroundColor Yellow
        exit 1
    }
} 