.PHONY: all build run down clean restart logs

# Команда по умолчанию (сборка всех jar и запуск docker compose)
all: build run

# Сборка jar-файлов всех сервисов параллельно/последовательно без тестов
build:
	mvn -f api-gateway/pom.xml clean package -DskipTests
	mvn -f bank-card-management-system/pom.xml clean package -DskipTests
	mvn -f hotel-booking-system/pom.xml clean package -DskipTests

# Запуск контейнеров с пересборкой образов
run:
	docker compose up --build -d

# Сборка и запуск в foreground (с выводом логов в терминал)
run-attached: build
	docker compose up --build

# Остановка и удаление контейнеров
down:
	docker compose down

# Перезапуск всего проекта
restart: down build run

# Очистка артефактов сборки
clean:
	mvn -f api-gateway/pom.xml clean
	mvn -f bank-card-management-system/pom.xml clean
	mvn -f hotel-booking-system/pom.xml clean

# Просмотр логов всех сервисов в реальном времени
logs:
	docker compose logs -f