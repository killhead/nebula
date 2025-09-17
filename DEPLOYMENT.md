# Руководство по развертыванию NebulaGraph в Railway

## 🎯 Цель

Этот документ содержит пошаговые инструкции по развертыванию NebulaGraph в Railway.

## 📋 Предварительные требования

- Аккаунт на [Railway](https://railway.app)
- GitHub репозиторий с кодом
- Docker (для локального тестирования)
- Git

## 🚀 Пошаговое развертывание

### Шаг 1: Подготовка репозитория

1. **Склонируйте репозиторий:**
   ```bash
   git clone https://github.com/killhead/nebula.git
   cd nebula
   ```

2. **Проверьте структуру файлов:**
   ```bash
   ls -la
   # Должны быть: Dockerfile, docker-compose.yml, config/, scripts/, README.md
   ```

### Шаг 2: Локальное тестирование

1. **Запустите локально:**
   ```bash
   docker-compose up -d
   ```

2. **Проверьте статус:**
   ```bash
   docker-compose ps
   ```

3. **Проверьте логи:**
   ```bash
   docker-compose logs nebula-graphd
   ```

4. **Откройте Studio:**
   - URL: http://localhost:7001
   - Host: localhost
   - Port: 9669
   - User: root
   - Password: nebula

5. **Остановите локально:**
   ```bash
   docker-compose down
   ```

### Шаг 3: Настройка Railway

1. **Войдите в Railway:**
   - Откройте [railway.app](https://railway.app)
   - Войдите через GitHub

2. **Создайте новый проект:**
   - Нажмите "New Project"
   - Выберите "Deploy from GitHub repo"
   - Найдите и выберите репозиторий `killhead/nebula`

3. **Настройте переменные окружения:**
   - Перейдите в Settings → Variables
   - Добавьте следующие переменные:

   ```
   NEBULA_META_SERVER_ADDRS=127.0.0.1:9559
   NEBULA_LOCAL_IP=0.0.0.0
   NEBULA_PORT=9669
   NEBULA_WS_HTTP_PORT=19669
   NEBULA_USER=root
   NEBULA_PASSWORD=nebula
   NEBULA_DATA_PATH=/data
   NEBULA_LOG_DIR=/logs
   NEBULA_LOG_LEVEL=INFO
   ```

### Шаг 4: Развертывание

1. **Railway автоматически:**
   - Обнаружит Dockerfile
   - Начнет сборку образа
   - Развернет приложение

2. **Мониторинг развертывания:**
   - Перейдите в Deployments
   - Следите за логами сборки
   - Дождитесь успешного развертывания

3. **Получите URL:**
   - После развертывания Railway предоставит URL
   - Например: `https://nebula-production-xxxx.up.railway.app`

### Шаг 5: Проверка развертывания

1. **Проверьте статус:**
   ```bash
   curl https://your-app-url.up.railway.app:19669/status
   ```

2. **Подключитесь через CLI:**
   ```bash
   # Установите NebulaGraph Console
   docker run -it --rm vesoft/nebula-console:latest \
     --addr=your-app-url.up.railway.app --port=9669 \
     --user=root --password=nebula
   ```

3. **Тестовые запросы:**
   ```cypher
   SHOW HOSTS;
   SHOW SPACES;
   ```

## 🔧 Настройка после развертывания

### Настройка домена (опционально)

1. **В Railway Dashboard:**
   - Перейдите в Settings → Domains
   - Добавьте ваш домен
   - Настройте DNS записи

### Настройка мониторинга

1. **Health Check:**
   - Railway автоматически проверяет `/status`
   - Настройте алерты в Railway Dashboard

2. **Логи:**
   - Логи доступны в Railway Dashboard
   - Настройте уведомления об ошибках

## 🚨 Устранение неполадок

### Проблемы с развертыванием

1. **Ошибка сборки:**
   - Проверьте Dockerfile
   - Убедитесь, что все файлы в репозитории
   - Проверьте логи сборки

2. **Ошибка запуска:**
   - Проверьте переменные окружения
   - Убедитесь, что порты настроены правильно
   - Проверьте логи приложения

3. **Проблемы с подключением:**
   - Проверьте URL и порты
   - Убедитесь, что приложение запущено
   - Проверьте настройки сети

### Частые ошибки

1. **"Connection refused":**
   - Приложение не запущено
   - Неправильный порт
   - Проблемы с сетью

2. **"Authentication failed":**
   - Неправильный пользователь/пароль
   - Проблемы с конфигурацией

3. **"Out of memory":**
   - Недостаточно ресурсов в Railway
   - Оптимизируйте конфигурацию

## 📊 Мониторинг и обслуживание

### Регулярные проверки

1. **Статус приложения:**
   ```bash
   curl https://your-app-url.up.railway.app:19669/status
   ```

2. **Использование ресурсов:**
   - Проверяйте в Railway Dashboard
   - Мониторьте CPU и память

3. **Логи:**
   - Регулярно проверяйте логи
   - Настройте алерты на ошибки

### Обновления

1. **Обновление кода:**
   - Внесите изменения в репозиторий
   - Railway автоматически пересоберет и развернет

2. **Обновление NebulaGraph:**
   - Обновите версию в Dockerfile
   - Проверьте совместимость конфигурации

## 🔒 Безопасность

### Рекомендации

1. **Измените пароли по умолчанию**
2. **Используйте HTTPS**
3. **Настройте firewall**
4. **Регулярно обновляйте**

### Настройка аутентификации

1. **Включите аутентификацию:**
   ```ini
   --enable_authorize=true
   ```

2. **Создайте пользователей:**
   ```cypher
   CREATE USER 'admin' WITH PASSWORD 'secure_password';
   GRANT ROLE ADMIN ON * TO 'admin';
   ```

## 📈 Масштабирование

### Ограничения Railway

- Railway имеет ограничения по ресурсам
- Для production рекомендуется использовать другие платформы

### Альтернативы для production

- AWS ECS/Fargate
- Google Cloud Run
- Azure Container Instances
- DigitalOcean App Platform

## 📞 Поддержка

- [NebulaGraph Documentation](https://docs.nebula-graph.io/)
- [Railway Documentation](https://docs.railway.app/)
- [GitHub Issues](https://github.com/killhead/nebula/issues)
