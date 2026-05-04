#!/bin/sh

ORION="http://orion:1026"
SERVICE="user10000000000000000000000000000001"

echo "Esperando a que Orion esté listo..."
until curl -sf "${ORION}/version" > /dev/null; do
  sleep 2
done
echo "Orion disponible. Insertando productos..."

create() {
  curl -s -o /dev/null -w "%{http_code}" \
    -X POST "${ORION}/v2/entities" \
    -H "Content-Type: application/json" \
    -H "Fiware-Service: ${SERVICE}" \
    -H "Fiware-ServicePath: /" \
    -d "$1"
  echo ""
}

create '{
  "id": "urn:ngsi-ld:InventoryItem:001",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Manzana roja" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 50 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.20 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:002",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Plátano" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 30 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.90 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:003",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Tomate" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 40 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.80 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:004",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Lechuga" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 20 },
  "unit":     { "type": "Text",   "value": "Caja" },
  "price":    { "type": "Number", "value": 0.60 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:005",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Zanahoria" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 25 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.70 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:006",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Naranja" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 60 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.00 }
}'

echo "Productos insertados."
