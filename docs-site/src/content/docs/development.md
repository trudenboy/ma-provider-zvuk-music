---
title: Окружение разработки
description: Настройка окружения разработки, инструменты и рабочий процесс для провайдера Zvuk Music
---

## Требования

- Python 3.12+
- [uv](https://docs.astral.sh/uv/) — `curl -LsSf https://astral.sh/uv/install.sh | sh`
- ffmpeg 6.1+ (для интеграционных тестов MA)
  - macOS: `brew install ffmpeg`
  - Ubuntu: `sudo apt-get install ffmpeg`
- Форк [trudenboy/ma-server](https://github.com/trudenboy/ma-server) (для dev-сервера)

## Установка

```bash
./scripts/setup.sh
```

Перезапускайте после `git pull` — версия моделей MA может измениться.

## Запуск тестов

```bash
# Только unit-тесты (быстро, без MA-сервера)
pytest tests/ -m "not integration"

# Полный набор тестов
pytest tests/

# С отчётом покрытия
pytest --cov=provider --cov-report=html tests/
```

## Ежедневный рабочий процесс

### Наименование веток

```
feature/<описание>    # новый функционал
fix/<описание>        # исправления багов
chore/<описание>      # обслуживание, обновление зависимостей
```

`<описание>` — kebab-case, 2–4 слова. Примеры:
```
feature/radio-mode-support
fix/seek-position-reset
chore/update-deps
```

### Жизненный цикл feature-ветки

```bash
# 1. Создать ветку от dev
git checkout dev && git pull
git checkout -b feature/radio-mode-support

# 2. Разработка + тесты
pytest tests/
pre-commit run --all-files

# 3. PR: feature/* → dev
git push origin feature/radio-mode-support
gh pr create --base dev --title "feat: add radio mode support"

# 4. CI проходит → merge → удалить ветку
git push origin --delete feature/radio-mode-support
```

## Запуск dev-сервера

Запускает Music Assistant с актуальным кодом провайдера (без Docker, изолированно от остальной работы):

```bash
./scripts/dev-server.sh
# UI: http://localhost:8095
```

Требует форк ma-server. Порядок обнаружения:
1. `MA_SERVER_REPO=/path/to/ma-server ./scripts/dev-server.sh`
2. `echo "/path/to/ma-server" > ma-server.repo` (gitignored)
3. Автообнаружение: `../ma-server`, `~/Projects/ma-server`, `~/src/ma-server`, `~/dev/ma-server`

:::note
Dev-сервер занимает порт 8095 — не запускайте `pytest tests/` (с фикстурой mass) одновременно.
:::

## Качество кода

```bash
pre-commit run --all-files
```

Запускает: ruff (lint + format), mypy (проверка типов), codespell.

## Conventional Commits

Используются для автоматической генерации CHANGELOG:
```
feat: add radio mode support
fix: fix seek position reset
chore: update zvuk dependencies
test: add streaming test
```

## Процесс релиза

1. PR: `dev` → `main`
2. Слияние в `main`
3. Запустить Release workflow: Actions → Release → Run workflow → ввести версию (например `1.1.0`)
4. Workflow создаёт тег и GitHub Release (с авто-сгенерированными release notes)
5. Авто-создаётся sync-PR в [trudenboy/ma-server](https://github.com/trudenboy/ma-server)

## Устранение неполадок

**`sync-to-fork.yml` падает — истёк FORK_SYNC_PAT**

Обнови PAT (нужны права `contents:write` на `trudenboy/ma-server`) и обнови секрет:

```bash
gh secret set FORK_SYNC_PAT --body "$NEW_PAT" --repo trudenboy/ma-provider-zvuk-music
```

**Порт 8095 занят**

```bash
lsof -i :8095
kill <PID>
```

**`dev-server.sh` не находит форк**

```bash
# Вариант 1: переменная окружения
MA_SERVER_REPO=~/work/ma-server ./scripts/dev-server.sh

# Вариант 2: файл локального переопределения (gitignored)
echo "~/work/ma-server" > ma-server.repo
```

## Чеклист E2E

Запускай перед upstream PR или крупным релизом:

- [ ] Провайдер подключается успешно
- [ ] Browse → Zvuk Music открывается, библиотека отображается
- [ ] Поиск треков/исполнителей/альбомов возвращает результаты
- [ ] Трек воспроизводится корректно, перемотка работает
- [ ] Избранные треки синхронизируются в библиотеку
