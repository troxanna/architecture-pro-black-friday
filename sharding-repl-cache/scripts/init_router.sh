#!/bin/bash

echo "🚀 Настройка роутера mongos_router и заполнение тестовой базы данными..."

docker exec -i mongos_router mongosh --port 27020 <<EOF
// 1. Подключаем реплика-сеты шардов к роутеру
sh.addShard("shard1_set/shard1-1:27018");
sh.addShard("shard2_set/shard2-1:27019");

// 2. Включаем шардирование для базы
sh.enableSharding("somedb");

// 3. Настраиваем разделение коллекции по хэшу
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });

// 4. Переключаемся на базу и создаем 1000 документов
use somedb;
for(var i = 0; i < 1000; i++) {
  db.helloDoc.insertOne({ age: i, name: "ly" + i });
}

print("📊 Всего документов в коллекции helloDoc:");
db.helloDoc.countDocuments();

exit
EOF

echo "✅ Роутер полностью настроен, данные распределены!"
