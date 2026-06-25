#!/bin/bash

echo "🚀 Инициализация реплика-сета для Шарда 1 (3 ноды)..."
docker exec -i shard1-1 mongosh --port 27018 <<EOF
rs.initiate({
  _id: "shard1_set",
  members: [
    { _id: 0, host: "shard1-1:27018" },
    { _id: 1, host: "shard1-2:27018" },
    { _id: 2, host: "shard1-3:27018" }
  ]
});
exit
EOF

echo "⏳ Ожидание 8 секунд для выбора Primary в Шарде 1..."
sleep 8

echo "🚀 Инициализация реплика-сета для Шарда 2 (3 ноды)..."
docker exec -i shard2-1 mongosh --port 27019 <<EOF
rs.initiate({
  _id: "shard2_set",
  members: [
    { _id: 0, host: "shard2-1:27019" },
    { _id: 1, host: "shard2-2:27019" },
    { _id: 2, host: "shard2-3:27019" }
  ]
});
exit
EOF

echo "✅ Команды инициализации реплик для обоих шардов успешно отправлены!"

