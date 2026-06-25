#!/bin/bash

echo "🚀 Настройка роутера mongos_router и заполнение тестовой базы данными..."

docker exec -i mongos_router mongosh --port 27020 <<EOF
sh.addShard("shard1_set/shard1:27018");
sh.addShard("shard2_set/shard2:27019");

sh.enableSharding("somedb");

sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });

use somedb;
for(var i = 0; i < 1000; i++) {
  db.helloDoc.insertOne({ age: i, name: "ly" + i });
}

print("📊 Всего документов в коллекции helloDoc:");
db.helloDoc.countDocuments();

exit
EOF

echo "✅ Роутер полностью настроен, данные распределены по шардам!"
