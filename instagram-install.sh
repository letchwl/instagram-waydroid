#!/bin/bash
set -e

APK_NAME="com.instagram.android.apk"
APK_PATH="$HOME/Downloads/$APK_NAME"
PACKAGE_NAME="com.instagram.android"
DESKTOP_FILE="$HOME/.local/share/applications/instagram.desktop"

echo "📦 Verificando se WayDroid está instalado..."
if ! command -v waydroid &>/dev/null; then
  echo "⚠️ WayDroid não encontrado. Instalando..."
  yay -S --noconfirm waydroid lxc android-tools python-pillow git wget curl
fi

echo "🔍 Verificando APK..."
if [ ! -f "$APK_PATH" ]; then
  echo "❌ APK não encontrado em $APK_PATH"
  echo "⏬ Coloque o APK funcional com esse nome na pasta ~/Downloads e rode o script novamente."
  exit 1
fi

echo "🚀 Iniciando WayDroid container e sessão..."
if [ ! -d /var/lib/waydroid/lxc/waydroid ]; then
  echo "❌ Waydroid não está inicializado. Execute: sudo waydroid init"
  exit 1
fi

sudo systemctl start waydroid-container || true
waydroid session start &
sleep 5

echo "🌐 Exportando variáveis de ambiente para o shell atual..."
export $(env | grep -E 'WAYDROID|DBUS_SESSION_BUS_ADDRESS' | xargs)

echo "📤 Enviando APK para o container..."
WAYDROID_IP=$(waydroid status | grep "IP address" | awk '{print $3}')
echo "⌛ Aguardando ADB conectar ao Waydroid..."

max_tries=15
count=0
until adb devices | grep -q "192.168.240.112:5555.*device"; do
  adb connect 192.168.240.112:5555 >/dev/null
  count=$((count + 1))
  if [ $count -ge $max_tries ]; then
    echo "❌ ADB não conectou como 'device' após $max_tries tentativas."
    adb devices
    exit 1
  fi
  echo "🔁 Aguardando dispositivo ficar pronto... ($count)"
  sleep 2
done

echo "✅ Dispositivo conectado e pronto via ADB!"
adb devices

adb wait-for-device
adb push "$APK_PATH" /data/local/tmp/instagram.apk

echo "📲 Instalando Instagram no WayDroid..."
sudo waydroid shell <<EOF
pm install -r /data/local/tmp/instagram.apk
exit
EOF

echo "🧷 Criando atalho de aplicativo..."
ICON_SRC="$HOME/instagram-waydroid/assets/instagram_icon.png"
ICON_DST="$HOME/.local/share/icons/instagram_icon.png"

echo "🖼️ Copiando ícone para o local de ícones do usuário..."
mkdir -p "$(dirname "$ICON_DST")"
cp "$ICON_SRC" "$ICON_DST"

mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Instagram
Exec=waydroid app launch $PACKAGE_NAME
Icon=$ICON_DST
Type=Application
Terminal=false
Categories=Network;
EOF

chmod +x "$DESKTOP_FILE"

echo "✅ Tudo pronto! Você pode abrir o Instagram pelo menu de aplicativos."

