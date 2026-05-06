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
  "id": "urn:ngsi-ld:InventoryItem:002",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Plátano" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.90 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:003",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Tomate" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.80 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:004",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Lechuga" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "Caja" },
  "price":    { "type": "Number", "value": 0.60 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:005",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Zanahoria" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.70 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:006",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Naranja" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.00 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:007",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Manzana Fuji" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.55 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:008",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Manzana Royal Gala" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.45 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:009",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Manzana Golden" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.35 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:010",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Patatas" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.55 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:011",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Cebolla Dulce" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.20 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:012",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Cebolla Normal" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.85 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:013",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Pimiento Rojo" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.95 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:014",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Pimiento Verde" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.75 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:015",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Pimiento Italiano" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.65 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:016",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Calabacines" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.25 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:017",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Pepinos" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.95 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:018",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Berenjena Negra" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.35 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:019",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Berenjena Rayada" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.45 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:020",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Judía Ancha" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 2.50 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:021",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Judía Fina" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 2.80 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:022",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Judía Gancho" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 3.10 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:023",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Alcachofa" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 2.30 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:024",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Fresas" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "Caja" },
  "price":    { "type": "Number", "value": 3.50 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:025",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Uvas" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 2.15 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:026",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Cerezas" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 4.50 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:027",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Melones" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 3.00 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:028",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Sandias" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 4.00 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:029",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Tomate Terreno Gordo" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.85 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:030",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Tomate Terreno Bola" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.65 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:031",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Zanahoria de Rama" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "Manojo" },
  "price":    { "type": "Number", "value": 1.25 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:032",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Zanahoria Suelta" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 0.75 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:033",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Champiñones" },
  "category": { "type": "Text",   "value": "Setas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 3.20 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:034",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Setas" },
  "category": { "type": "Text",   "value": "Setas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 4.10 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:035",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Shitake" },
  "category": { "type": "Text",   "value": "Setas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 8.50 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:036",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Calabaza Totanera" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 2.50 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:037",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Calabaza Cacahuete" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 2.10 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:038",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Nabos y Chirivías" },
  "category": { "type": "Text",   "value": "Hortalizas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "Manojo" },
  "price":    { "type": "Number", "value": 1.60 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:039",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Aguacate" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 4.60 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:040",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Mango" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 3.75 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:041",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Piña" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 2.20 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:042",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Lechugas Pequeñas" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 0.55 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:043",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Lechugas Grandes" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 0.95 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:044",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Lechuga Iceberg" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 1.10 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:045",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Rábanos" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "Manojo" },
  "price":    { "type": "Number", "value": 0.85 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:046",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Acelgas" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "Manojo" },
  "price":    { "type": "Number", "value": 1.30 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:047",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Espinacas" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "Manojo" },
  "price":    { "type": "Number", "value": 1.60 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:048",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Puerro" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 0.45 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:049",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Apio" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "ud" },
  "price":    { "type": "Number", "value": 1.15 }
}'

create '{
  "id": "urn:ngsi-ld:InventoryItem:050",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Hojas de Caldo" },
  "category": { "type": "Text",   "value": "Verduras" },
  "quantity": { "type": "Number", "value": 1 },
  "unit":     { "type": "Text",   "value": "Manojo" },
  "price":    { "type": "Number", "value": 1.05 }
}'

echo "Productos insertados."