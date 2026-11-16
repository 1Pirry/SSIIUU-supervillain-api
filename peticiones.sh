BASE="https://ssiiuu-supervillain-api.onrender.com"
: "${API_TOKEN:?Define API_TOKEN con un JWT vigente obtenido del callback OAuth de Render.}"
TOKEN="$API_TOKEN"

echo "=== 1. Perfil de usuario autenticado (GET /api/users/secure) ==="
curl -i "$BASE/api/users/secure" -H "Authorization: Bearer $TOKEN"
echo ""

echo "=== 2. Crear villano con token (POST /api/villains) ==="
curl -i -X POST "$BASE/api/villains" \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"name":"Gru","alias":"El Ladron de la Luna","evilLevel":8000}'
echo ""

echo "=== 3. Listar villanos sin token (GET /api/villains) -> debe ser 401 ==="
curl -i "$BASE/api/villains"
echo ""

echo "=== 4. Listar villanos con token (GET /api/villains) -> 200 OK ==="
curl -i "$BASE/api/villains" -H "Authorization: Bearer $TOKEN"
echo ""

###########################################################################################
###########################################################################################
####### AÑADIDA LA SALIDA DE OTRO RECURSO SECURIZADO: DEVICES (MÁQUINAS) ##################
###########################################################################################
###########################################################################################

echo "=== 5. Recurso Devices sin token (GET /api/devices) -> debe ser 401 ==="
curl -i "$BASE/api/devices"
echo ""

echo "=== 6. Recurso Devices con token (GET /api/devices) -> 200 OK ==="
curl -i "$BASE/api/devices" -H "Authorization: Bearer $TOKEN"
echo ""
