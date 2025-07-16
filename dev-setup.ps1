# Development Setup Script
# This script sets up a fast development environment

Write-Host "🚀 Setting up Fast Development Environment..." -ForegroundColor Green

# Stop any running containers
Write-Host "🛑 Stopping existing containers..." -ForegroundColor Yellow
docker-compose down

# Start only essential services
Write-Host "📦 Starting essential services (RabbitMQ, Redis, MySQL)..." -ForegroundColor Cyan
docker-compose -f docker-compose.dev.yml up -d

Write-Host "✅ Essential services started!" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor White
Write-Host "1. Open multiple terminals and run:" -ForegroundColor Cyan
Write-Host "   Terminal 1: cd apps/api-gateway && npm run start:dev" -ForegroundColor Yellow
Write-Host "   Terminal 2: cd apps/auth-service && npm run start:dev" -ForegroundColor Yellow
Write-Host "   Terminal 3: cd apps/logger-microservice && npm run start:dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Your services will have hot reloading - changes will apply instantly!" -ForegroundColor Green
Write-Host ""
Write-Host "3. Access your services at:" -ForegroundColor Cyan
Write-Host "   API Gateway: http://localhost:3000" -ForegroundColor Yellow
Write-Host "   Swagger Docs: http://localhost:3000/api/docs" -ForegroundColor Yellow
Write-Host "   RabbitMQ Management: http://localhost:15672" -ForegroundColor Yellow
Write-Host ""
Write-Host "💡 Benefits:" -ForegroundColor White
Write-Host "   - Fast startup (no Docker build)" -ForegroundColor Green
Write-Host "   - Instant hot reloading" -ForegroundColor Green
Write-Host "   - Lower memory usage" -ForegroundColor Green
Write-Host "   - Better debugging experience" -ForegroundColor Green 