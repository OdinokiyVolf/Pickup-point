#!/bin/bash

# =================================================================
# Скрипт автоматической настройки ПВЗ (Тищенко, 2)
# =================================================================

echo "🚀 Запуск процесса установки окружения..."

# 1. Проверка наличия Node.js
if ! command -v node &> /dev/null
then
    echo "❌ Ошибка: Node.js не найден. Установите его с https://nodejs.org/"
    exit 1
fi

# 2. Создание package.json, если он отсутствует
if [ ! -f package.json ]; then
    echo "📦 Инициализация npm проекта..."
    npm init -y
fi

# 3. Установка необходимых зависимостей
echo "📥 Установка пакетов: express, sqlite3, body-parser..."
npm install express sqlite3 body-parser[cite: 1]

# 4. Инициализация базы данных SQLite
echo "🗄️ Настройка базы данных pvz.db..."
node <<EOF
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./pvz.db');

db.serialize(() => {
  // Создаем таблицу заказов, если её еще нет
  db.run(\`CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number TEXT NOT NULL,
    customer_name TEXT,
    status TEXT DEFAULT 'Прибыло',
    arrival_date DATETIME DEFAULT CURRENT_TIMESTAMP
  )\`);
  console.log('✅ Таблица "orders" готова к работе.');
});
db.close();
EOF

# 5. Проверка наличия основного файла сервера[cite: 1]
if [ ! -f server.js ]; then
    echo "⚠️ Внимание: Файл server.js не найден в текущей директории!"
else
    echo "🎉 Установка завершена успешно."
    echo "🌐 Запускаю сервер..."
    node server.js
fi
