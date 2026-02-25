---
title: Провайдер Zvuk Music
description: Документация провайдера Zvuk Music для Music Assistant
---
<img src="/ma-provider-zvuk-music/zvuk-icon.svg" alt="Zvuk Music" style="width: 64px; float: right; margin: 0 0 1rem 1.5rem;" />

[Music Assistant](https://music-assistant.io) поддерживает [Zvuk Music](https://zvuk.com) — российский стриминговый сервис.

Провайдер создан и поддерживается [TrudenBoy](https://github.com/TrudenBoy).

Реализован на основе библиотеки [zvuk-music](https://github.com/trudenboy/zvuk-music) (**неофициальный** клиент Zvuk Music API).

:::caution[Неофициальный провайдер]
Этот провайдер использует неофициальный клиент [Zvuk Music API](https://github.com/trudenboy/zvuk-music) и не аффилирован с компанией [Zvuk](https://zvuk.com) или её владельцами. API может измениться без предупреждения, что может привести к временной неработоспособности провайдера.
:::

:::note[Подписка]
Для полноценной работы всех функций, а так же проигрывания Lossless FLAC необходимо наличие подписки [Zvuk Prime](https://zvuk.com/sub). 
Без подписки полноценная работа провайдера не гарантируется.
:::

## Возможности

| Функция | Поддержка |
|:--------|:---------:|
| Исполнители, Альбомы, Треки, Плейлисты | ✅ |
| Поиск по каталогу | ✅ |
| Синхронизация библиотеки (двунаправленная) | ✅ |
| [Рекомендации](/ma-provider-zvuk-music/features/recommendations/) | ✅ |
| [Тексты песен](/ma-provider-zvuk-music/features/lyrics/) | ✅ |
| [Похожие треки / Радио-режим](/ma-provider-zvuk-music/features/similar-tracks/) | ✅ |
| Просмотр каталога (Browse) | ✅ |
| Управление плейлистами (создание, добавление, удаление треков) | ✅ |
| Максимальное качество | Lossless FLAC (с подпиской) |
| Способ входа | Токен (X-Auth-Token) |

Подробное описание каждой возможности — в разделе **[Возможности](/ma-provider-zvuk-music/features/recommendations/)** в боковом меню.

## Настройка

Для подключения необходим X-Auth-Token аккаунта Zvuk Music.

Инструкция по получению токена и описание всех параметров — на странице [Настройка](/ma-provider-zvuk-music/configuration/).

## Известные проблемы

- OAuth-токен может истечь и потребовать переавторизации
- Несколько аккаунтов Zvuk Music одновременно не поддерживаются

Полный список — на странице [Известные проблемы](/ma-provider-zvuk-music/known-issues/).
