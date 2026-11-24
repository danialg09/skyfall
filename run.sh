#!/usr/bin/env bash
set -e

ACTION="${1:-all}"

build_services() {
    echo -e "\033[0;36m===> [1/3] Building api-gateway...\033[0m"
    mvn -f api-gateway/pom.xml clean package -DskipTests

    echo -e "\033[0;36m===> [2/3] Building bank-card-management-system...\033[0m"
    mvn -f bank-card-management-system/pom.xml clean package -DskipTests

    echo -e "\033[0;36m===> [3/3] Building hotel-booking-system...\033[0m"
    mvn -f hotel-booking-system/pom.xml clean package -DskipTests
}

case "$ACTION" in
    build)
        build_services
        echo -e "\033[0;32m===> All services built successfully!\033[0m"
        ;;
    down)
        echo -e "\033[0;33m===> Stopping containers...\033[0m"
        docker compose down
        ;;
    clean)
        echo -e "\033[0;33m===> Cleaning build artifacts...\033[0m"
        mvn -f api-gateway/pom.xml clean
        mvn -f bank-card-management-system/pom.xml clean
        mvn -f hotel-booking-system/pom.xml clean
        echo -e "\033[0;32m===> Clean complete.\033[0m"
        ;;
    logs)
        docker compose logs -f
        ;;
    restart)
        echo -e "\033[0;33m===> Restarting stack...\033[0m"
        docker compose down
        build_services
        docker compose up --build -d
        echo -e "\033[0;32m===> Stack restarted in background!\033[0m"
        ;;
    *)
        build_services
        echo -e "\033[0;36m===> Starting containers via docker compose...\033[0m"
        docker compose up --build
        ;;
esac