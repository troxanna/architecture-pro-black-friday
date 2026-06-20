#!/bin/bash

echo "========================================================="
echo "📊 КОМПЛЕКСНАЯ ПРОВЕРКА КЛАСТЕРА (ДАННЫЕ + РЕПЛИКАЦИЯ)"
echo "========================================================="

# 1. Проверяем количество реплик в группах
echo "👥 [КОЛИЧЕСТВО АКТИВНЫХ РЕПЛИК В СЕТЯХ]:"

CONFIG_REPLICAS=$(docker exec -i configSrv1 mongosh --port 27017 --quiet --eval "rs.status().members.length")
SHARD1_REPLICAS=$(docker exec -i shard1-1 mongosh --port 27018 --quiet --eval "rs.status().members.length")
SHARD2_REPLICAS=$(docker exec -i shard2-1 mongosh --port 27019 --quiet --eval "rs.status().members.length")

echo "  • Реплика-сет Config Server : $CONFIG_REPLICAS ноды"
echo "  • Реплика-сет Shard 1       : $SHARD1_REPLICAS ноды"
echo "  • Реплика-сет Shard 2       : $SHARD2_REPLICAS ноды"

echo "--------------------------------------------------------"

# 2. Проверяем документы и шардинг через роутер
docker exec -i mongos_router mongosh --port 27020 <<EOF
use somedb;

print("📝 [ОБЩЕЕ КОЛИЧЕСТВО ДОКУМЕНТОВ В БАЗЕ]");
print("  Всего записей в helloDoc:", db.helloDoc.countDocuments());

print("\n📈 [РАСПРЕДЕЛЕНИЕ ДОКУМЕНТОВ ПО ШАРДАМ]");
db.helloDoc.getShardDistribution();

exit
EOF

echo "========================================================="
echo "✅ Проверка кластера завершена!"
