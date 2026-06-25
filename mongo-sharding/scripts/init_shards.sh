#!/bin/bash

echo "🚀 Инициализация первого шарда (shard1)..."
docker exec -i shard1 mongosh --port 27018 <<EOF
rs.initiate({
  _id: "shard1_set",
  members: [
    { _id: 0, host: "shard1:27018" }
  ]
});
exit
EOF

echo "⏳ Ожидание 5 секунд для стабилизации первого шарда..."
sleep 5

echo "🚀 Инициализация второго шарда (shard2)..."
docker exec -i shard2 mongosh --port 27019 <<EOF
rs.initiate({
  _id: "shard2_set",
  members: [
    { _id: 0, host: "shard2:27019" }
  ]
});
exit
EOF

echo "✅ Команды инициализации для shard1 и shard2 успешно отправлены!"
