[![Actions Status](https://github.com/GolovkoStepan/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/GolovkoStepan/rails-project-66/actions)
[![CI](https://github.com/GolovkoStepan/rails-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/GolovkoStepan/rails-project-66/actions/workflows/ci.yml)

# Анализатор качества репозиториев

Проект Github Quality — это сервис, где разработчики могут запустить проверки кода в своих репозиториях и получить отчёт о состоянии кодовой базы, текущие ошибки. Аналог: [codeclimate.com](https://codeclimate.com)

### Переменные окружения, необходимые для работы
Скопировать файл переменных:
```bash
cp .env.example .env.local
```
Заполнить значения следуя описанию:
```bash
GITHUB_CLIENT_ID=%github client id%
GITHUB_CLIENT_SECRET=%github client secret%
REDIS_URL=%адрес подключения к redis%
BASE_URL=%host развернутого приложения%
SMTP_USERNAME=%логин gmail%
SMTP_PASSWORD=%пароль для приложений%
```

### Дополнительные зависимости
- PostgreSQL https://www.postgresql.org
- Redis https://redis-docs.ru

### Установка библиотек проекта и подготовка БД
```bash
make setup
```

### Запуск приложения
```bash
make start
```

### Запуск тестов и проверок кода
```bash
make check
```

Развернутое приложение: https://stepangolovko.tech
