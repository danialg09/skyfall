param (
    [string]$Action = "all"
)

$ErrorActionPreference = "Stop"

function Build-Services {
    Write-Host "===> [1/3] Building api-gateway..." -ForegroundColor Cyan
    mvn -f api-gateway/pom.xml clean package -DskipTests

    Write-Host "===> [2/3] Building bank-card-management-system..." -ForegroundColor Cyan
    mvn -f bank-card-management-system/pom.xml clean package -DskipTests

    Write-Host "===> [3/3] Building hotel-booking-system..." -ForegroundColor Cyan
    mvn -f hotel-booking-system/pom.xml clean package -DskipTests
}

switch ($Action.ToLower()) {
    "build" {
        Build-Services
        Write-Host "===> All services built successfully!" -ForegroundColor Green
    }
    "down" {
        Write-Host "===> Stopping containers..." -ForegroundColor Yellow
        docker compose down -v
    }
    "clean" {
        Write-Host "===> Cleaning build artifacts..." -ForegroundColor Yellow
        mvn -f api-gateway/pom.xml clean
        mvn -f bank-card-management-system/pom.xml clean
        mvn -f hotel-booking-system/pom.xml clean
        Write-Host "===> Clean complete." -ForegroundColor Green
    }
    "logs" {
        docker compose logs -f
    }
    "restart" {
        Write-Host "===> Restarting stack..." -ForegroundColor Yellow
        docker compose down
        Build-Services
        docker compose up --build -d
        Write-Host "===> Stack restarted in background!" -ForegroundColor Green
    }
    default {
        Build-Services
        Write-Host "===> Starting containers via docker compose..." -ForegroundColor Cyan
        docker compose up --build
    }
}