
[← Разработка](development.md) · [← Участие в разработке](contributing.md) · [README](../README.md)

# Zvuk Music — Руководство по тестированию

## Быстрый старт

```bash
uv run pytest provider/tests/ -v
```

С отчётом о покрытии:

```bash
uv run pytest provider/tests/ -v --cov=provider/ --cov-report=term-missing
```

## CI-пайплайн

Каждый push и PR запускают два параллельных задания через `test.yml`:

| Задание | Что делает |
|---------|-----------|
| `test-*` | Запускает pytest с проверкой покрытия, загружает отчёт в Codecov |
| `lint-*` | Запускает ruff, mypy, codespell, pre-commit |


Тесты запускаются на основе `music-assistant/server@dev` (без форка — лёгкий CI).

## Инструменты

| Инструмент | Назначение |
|-----------|-----------|
| `uv` | Управление виртуальным окружением и зависимостями |
| `Python 3.12` | Целевая версия языка |
| `pytest` | Фреймворк для тестов |
| `pytest-cov` | Сбор данных о покрытии |
| `Codecov` | Загрузка отчётов о покрытии (автоматически в CI) |
| `ruff` | Линтер и форматтер Python |
| `mypy` | Статический анализ типов |
| `codespell` | Проверка орфографии в исходном коде |
| `pre-commit` | Хуки для проверки перед коммитом |

## Запуск линтеров локально

Запустить все хуки pre-commit (рекомендуется перед PR):

```bash
uv run pre-commit run --all-files
```

Только проверка типов:

```bash
uv run mypy provider/
```

Только линтинг:

```bash
uv run ruff check provider/
uv run ruff format --check provider/
```

## Покрытие

Отчёты о покрытии автоматически загружаются в Codecov при каждом push в CI.
Локально просмотреть покрытие:

```bash
uv run pytest provider/tests/ --cov=provider/ --cov-report=html
open htmlcov/index.html
```

## E2E тесты (Playwright)

E2E тесты проверяют реальный функционал провайдера через браузер против живого MA-сервера. Запускаются только локально — не в CI.

### Требования

- Docker (для запуска MA)
- `ZVUK_TOKEN` в файле `.env`
- Установленные e2e-зависимости и браузер Playwright:

```bash
uv pip install ".[e2e]"
playwright install chromium
```

### Запуск

```bash
# Все e2e тесты (запускает Docker, ждёт готовности, тестирует, останавливает)
./scripts/e2e.sh

# Конкретные тесты
./scripts/e2e.sh -k test_search

# С видимым браузером
./scripts/e2e.sh --headed
```

### Структура

```
tests/e2e/
  conftest.py       — фикстуры (Docker lifecycle, браузер, авторизация, настройка провайдера)
  test_connect.py   — провайдер подключается, нет ошибок
  test_browse.py    — библиотека, плейлисты, обложки
  test_search.py    — поиск треков/артистов/альбомов/плейлистов
  test_playback.py  — воспроизведение, отсутствие фриза, seek
```

### Маркеры

Все e2e тесты помечены `@pytest.mark.e2e` и `@pytest.mark.integration`. Они не затрагивают обычный запуск unit-тестов:

```bash
# Unit-тесты (по умолчанию в CI)
pytest tests/ -m "not integration"

# Только e2e
pytest tests/e2e/ -m e2e
```

## Если CI упал

Если тесты или линтеры упали в CI, автоматически создаётся GitHub-задача с меткой `incident:ci`.
Подробнее о процессе работы с инцидентами: [Управление инцидентами](incident-management.md).
