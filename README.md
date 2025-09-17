# NebulaGraph Railway Deployment

Этот репозиторий содержит конфигурацию для развертывания NebulaGraph в Railway.

## 🚀 Быстрый старт

### Локальное тестирование

1. **Клонируйте репозиторий:**
   ```bash
   git clone https://github.com/killhead/nebula.git
   cd nebula
   ```

2. **Запустите локально с Docker Compose:**
   ```bash
   docker-compose up -d
   ```

3. **Проверьте статус сервисов:**
   ```bash
   docker-compose ps
   ```

4. **Откройте NebulaGraph Studio:**
   - URL: http://localhost:7001
   - Host: localhost
   - Port: 9669
   - User: root
   - Password: nebula

### Развертывание в Railway

1. **Подключите репозиторий к Railway:**
   - Зайдите на [railway.app](https://railway.app)
   - Создайте новый проект
   - Подключите GitHub репозиторий `killhead/nebula`

2. **Настройте переменные окружения в Railway:**
   ```
   NEBULA_META_SERVER_ADDRS=127.0.0.1:9559
   NEBULA_LOCAL_IP=0.0.0.0
   NEBULA_PORT=9669
   NEBULA_WS_HTTP_PORT=19669
   NEBULA_USER=root
   NEBULA_PASSWORD=nebula
   ```

3. **Разверните приложение:**
   - Railway автоматически обнаружит Dockerfile
   - Запустит сборку и развертывание

## 📁 Структура проекта

```
nebula/
├── Dockerfile                 # Docker образ для Railway
├── docker-compose.yml        # Локальная разработка
├── railway.json              # Конфигурация Railway
├── .railwayignore            # Исключения для Railway
├── env.example               # Пример переменных окружения
├── config/                   # Конфигурационные файлы
│   ├── nebula.conf          # Основная конфигурация
│   ├── graphd.conf          # Конфигурация GraphD
│   ├── metad.conf           # Конфигурация MetaD
│   └── storaged.conf        # Конфигурация StorageD
├── scripts/                  # Скрипты
│   ├── start.sh             # Скрипт запуска
│   └── healthcheck.sh       # Проверка здоровья
└── README.md                # Документация
```

## 🔧 Конфигурация

### Основные порты

- **9669** - NebulaGraph GraphD (основной API)
- **19669** - HTTP интерфейс GraphD
- **9559** - MetaD сервис
- **9779** - StorageD сервис
- **7001** - NebulaGraph Studio (только локально)

### Переменные окружения

| Переменная | Описание | По умолчанию |
|------------|----------|--------------|
| `NEBULA_META_SERVER_ADDRS` | Адреса Meta сервисов | `127.0.0.1:9559` |
| `NEBULA_LOCAL_IP` | Локальный IP | `0.0.0.0` |
| `NEBULA_PORT` | Порт GraphD | `9669` |
| `NEBULA_WS_HTTP_PORT` | HTTP порт | `19669` |
| `NEBULA_USER` | Пользователь | `root` |
| `NEBULA_PASSWORD` | Пароль | `nebula` |

## 🛠️ Использование

### Подключение к NebulaGraph

1. **Через NebulaGraph Studio (локально):**
   - Откройте http://localhost:7001
   - Введите данные подключения

2. **Через CLI:**
   ```bash
   # Установите NebulaGraph Console
   docker run -it --rm vesoft/nebula-console:latest \
     --addr=localhost --port=9669 --user=root --password=nebula
   ```

3. **Через Python:**
   ```python
   from nebula3.gclient.net import ConnectionPool
   from nebula3.Config import Config
   
   config = Config()
   config.max_connection_pool_size = 10
   
   connection_pool = ConnectionPool()
   connection_pool.init([('localhost', 9669)], config)
   
   # Получить сессию
   session = connection_pool.get_session('root', 'nebula')
   ```

### Примеры запросов

```cypher
# Создать пространство
CREATE SPACE IF NOT EXISTS test_space (partition_num=10, replica_factor=1);

# Использовать пространство
USE test_space;

# Создать теги
CREATE TAG IF NOT EXISTS person(name string, age int);

# Создать рёбра
CREATE EDGE IF NOT EXISTS knows(weight double);

# Вставить данные
INSERT VERTEX person(name, age) VALUES "alice":("Alice", 25);
INSERT VERTEX person(name, age) VALUES "bob":("Bob", 30);
INSERT EDGE knows(weight) VALUES "alice" -> "bob":(0.8);

# Запрос данных
MATCH (a:person)-[e:knows]->(b:person) 
RETURN a.name, e.weight, b.name;
```

## 🚨 Ограничения Railway

- **Ресурсы**: Ограниченные CPU, память и диск
- **Персистентность**: Данные могут быть потеряны при перезапуске
- **Производительность**: Не подходит для высоконагруженных систем
- **Масштабирование**: Ограниченные возможности масштабирования

## 🔍 Мониторинг

### Health Check

Railway автоматически проверяет здоровье приложения через:
- HTTP endpoint: `http://localhost:19669/status`
- Скрипт: `scripts/healthcheck.sh`

### Логи

Логи доступны в Railway Dashboard или через:
```bash
# Локально
docker-compose logs -f nebula-graphd
```

## 🆘 Устранение неполадок

### Проблемы с подключением

1. **Проверьте статус сервисов:**
   ```bash
   docker-compose ps
   ```

2. **Проверьте логи:**
   ```bash
   docker-compose logs nebula-graphd
   ```

3. **Проверьте порты:**
   ```bash
   netstat -tlnp | grep 9669
   ```

### Проблемы с Railway

1. **Проверьте переменные окружения**
2. **Убедитесь, что Dockerfile корректен**
3. **Проверьте логи развертывания в Railway Dashboard**

## 📚 Полезные ссылки

- [NebulaGraph Documentation](https://docs.nebula-graph.io/)
- [NebulaGraph GitHub](https://github.com/vesoft-inc/nebula)
- [Railway Documentation](https://docs.railway.app/)
- [NebulaGraph Studio](https://github.com/vesoft-inc/nebula-graph-studio)

## 📄 Лицензия

MIT License

## 🤝 Вклад в проект

1. Fork репозиторий
2. Создайте feature branch
3. Commit изменения
4. Push в branch
5. Создайте Pull Request
