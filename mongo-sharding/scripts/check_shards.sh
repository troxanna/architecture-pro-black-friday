#!/bin/bash

echo "📊 Проверка распределения 1000 документов по шардам..."
echo "--------------------------------------------------------"

docker exec -i mongos_router mongosh --port 27020 <<EOF
use somedb;

print("\n1. [ОБЩЕЕ КОЛИЧЕСТВО ДОКУМЕНТОВ В БАЗЕ]");
print("Всего записей:", db.helloDoc.countDocuments());

print("\n2. [РАСПРЕДЕЛЕНИЕ ПО ШАРДАМ]");
db.helloDoc.getShardDistribution();

exit
EOF

echo "--------------------------------------------------------"
echo "✅ Проверка завершена!"
