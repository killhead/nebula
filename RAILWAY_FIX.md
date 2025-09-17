# Исправление ошибки Railway Deployment

## 🚨 Проблема

Railway healthcheck не проходит, потому что:
1. **GraphD не может запуститься без MetaD и StorageD**
2. **В Railway развертывается только один контейнер**
3. **Healthcheck проверяет `/status` до того, как все сервисы запустятся**

## ✅ Решение

### 1. Обновленный Dockerfile

Теперь Dockerfile:
- **Копирует все бинарные файлы** (MetaD, StorageD, GraphD) в один образ
- **Устанавливает curl** для healthcheck
- **Запускает все сервисы** через скрипт `start.sh`

### 2. Обновленный скрипт запуска

`scripts/start.sh` теперь:
- **Запускает MetaD первым** (обязательно для других сервисов)
- **Ждет готовности MetaD** (10 секунд)
- **Запускает StorageD** и ждет его готовности
- **Запускает GraphD** и ждет его готовности
- **Мониторит все сервисы** и перезапускает при сбоях

### 3. Обновленная конфигурация

Все конфигурационные файлы обновлены для **standalone режима**:
- **MetaD**: `local_ip=127.0.0.1` (внутренний)
- **StorageD**: `local_ip=127.0.0.1` (внутренний)  
- **GraphD**: `local_ip=0.0.0.0` (внешний доступ)

### 4. Обновленный healthcheck

- **Увеличен start-period** до 120 секунд
- **Увеличено количество retries** до 5
- **Увеличен timeout** в railway.json до 200 секунд

## 🚀 Как применить исправления

### 1. Зафиксируйте изменения

```bash
cd /home/dmitry/projects/texts/cases/profiler/nebula
git add .
git commit -m "Fix Railway deployment: standalone mode with all services"
git push origin main
```

### 2. Railway автоматически пересоберет

Railway обнаружит изменения и:
- Пересоберет Docker образ
- Развернет обновленную версию
- Запустит healthcheck с новыми настройками

### 3. Мониторинг развертывания

Следите за логами в Railway Dashboard:
- **Сборка**: должна пройти успешно
- **Запуск**: все три сервиса должны запуститься
- **Healthcheck**: должен пройти через 2-3 минуты

## 📊 Ожидаемые логи

После исправления вы должны увидеть:

```
Starting NebulaGraph on Railway...
Starting metad...
metad started with PID 123
Waiting for MetaD to be ready...
Starting storaged...
storaged started with PID 124
Waiting for StorageD to be ready...
Starting graphd...
graphd started with PID 125
Waiting for GraphD to be ready...
Checking service status...
metad is running (PID: 123)
storaged is running (PID: 124)
graphd is running (PID: 125)
All NebulaGraph services started successfully!
```

## 🔍 Проверка работоспособности

После успешного развертывания:

1. **Проверьте статус:**
   ```bash
   curl https://your-app-url.up.railway.app:19669/status
   ```

2. **Подключитесь через CLI:**
   ```bash
   docker run -it --rm vesoft/nebula-console:latest \
     --addr=your-app-url.up.railway.app --port=9669 \
     --user=root --password=nebula
   ```

3. **Выполните тестовые запросы:**
   ```cypher
   SHOW HOSTS;
   SHOW SPACES;
   ```

## ⚠️ Важные замечания

1. **Время запуска**: Полный запуск занимает 2-3 минуты
2. **Ресурсы**: Все три сервиса в одном контейнере требуют больше ресурсов
3. **Персистентность**: Данные могут быть потеряны при перезапуске Railway
4. **Производительность**: Для production рекомендуется использовать другие платформы

## 🆘 Если проблемы остаются

1. **Проверьте логи Railway** на наличие ошибок
2. **Убедитесь, что все файлы загружены** в репозиторий
3. **Проверьте переменные окружения** в Railway
4. **Попробуйте локально** с `docker-compose up`

## 📞 Поддержка

Если проблемы продолжаются:
- Проверьте [Railway Documentation](https://docs.railway.app/)
- Обратитесь к [NebulaGraph Community](https://github.com/vesoft-inc/nebula)
- Создайте issue в репозитории
