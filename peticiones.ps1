# Script para ejecutar en Windows 11 (PowerShell)
# Salida a respuestaServidor.txt: .\peticiones.ps1 | Out-File -FilePath respuestaServidor.txt -Encoding utf8

$BASE = "https://ssiiuu-supervillain-api.onrender.com"
$TOKEN = $env:API_TOKEN
if ([string]::IsNullOrWhiteSpace($TOKEN)) {
  throw "Define API_TOKEN con un JWT vigente obtenido del callback OAuth de Render."
}

Write-Output "=== 1. Perfil de usuario autenticado (GET /api/users/secure) ==="
curl.exe -s -i "$BASE/api/users/secure" -H "Authorization: Bearer $TOKEN"
Write-Output ""

Write-Output "=== 2. Crear villano con token (POST /api/villains) ==="
$VILLAIN = (Invoke-RestMethod -Method Post -Uri "$BASE/api/villains" -Headers @{ Authorization = "Bearer $TOKEN" } -ContentType "application/json" -Body '{"name":"Gru","alias":"El Ladron de la Luna","evilLevel":8000}').data
Write-Output "Villano creado: $($VILLAIN._id)"
Write-Output ""

Write-Output "=== 3. Listar villanos sin token (GET /api/villains) -> debe ser 401 ==="
curl.exe -s -i "$BASE/api/villains"
Write-Output ""

Write-Output "=== 4. Listar villanos con token (GET /api/villains) -> 200 OK ==="
curl.exe -s -i "$BASE/api/villains" -H "Authorization: Bearer $TOKEN"
Write-Output ""

Write-Output "###########################################################################################"
Write-Output "####### AÑADIDA LA SALIDA DE OTRO RECURSO SECURIZADO: DEVICES (MÁQUINAS) ##################"
Write-Output "###########################################################################################"
Write-Output ""

Write-Output "=== 5. Recurso Devices sin token (GET /api/devices) -> debe ser 401 ==="
curl.exe -s -i "$BASE/api/devices"
Write-Output ""

Write-Output "=== 6. Recurso Devices con token (GET /api/devices) -> 200 OK ==="
curl.exe -s -i "$BASE/api/devices" -H "Authorization: Bearer $TOKEN"
Write-Output ""

Write-Output "=== 7. Crear guarida para el ejemplo de POST global ==="
$LAIR = (Invoke-RestMethod -Method Post -Uri "$BASE/api/villains/$($VILLAIN._id)/lairs" -Headers @{ Authorization = "Bearer $TOKEN" } -ContentType "application/json" -Body '{"name":"Guarida para dispositivos","location":"Isla de Pascua"}').data
Write-Output "Guarida creada: $($LAIR._id)"
Write-Output ""

Write-Output "=== 8. Crear dispositivo global (POST /api/devices) ==="
$DEVICE = (Invoke-RestMethod -Method Post -Uri "$BASE/api/devices" -Headers @{ Authorization = "Bearer $TOKEN" } -ContentType "application/json" -Body (@{ name = "Rayo Encogedor"; status = "Cargando"; power = "1.21 Gigawatts"; lair = $LAIR._id } | ConvertTo-Json)).data
Write-Output ($DEVICE | ConvertTo-Json -Depth 5)
Write-Output ""
