#!/bin/bash
set -e

# Check if running on Debian-based system
if ! command -v apt &> /dev/null; then
    echo "❌ This script requires a Debian-based system with apt package manager"
    exit 1
fi

echo "🚀 Starting Debian Dev Environment Setup..."

echo "🔄 Updating and Upgrading system..."
sudo apt update && sudo apt upgrade -y

# Ensure essential tools are available
echo "📦 Installing essential tools first..."
sudo apt install -y curl wget

# Docker & Docker Compose
echo "🐳 Installing Docker and Docker Compose..."
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
echo "✅ Docker installed. You may need to log out and back in for group changes to take effect."

echo "📦 Installing base packages..."
sudo apt install -y curl wget git unzip gnupg software-properties-common apt-transport-https ca-certificates lsb-release build-essential zsh vlc python3 python3-pip

# PHP & Laravel
echo "🐘 Installing PHP 8.2 and extensions..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php8.2 php8.2-cli php8.2-common php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-bcmath php8.2-gd php8.2-soap php8.2-intl php8.2-readline

# Composer & Laravel Installer
echo "🎼 Installing Composer & Laravel installer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer global require laravel/installer
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Node.js (via NVM)
echo "🟢 Installing Node.js (LTS) via NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
# Install Node.js in a new shell session
sudo -u $SUDO_USER bash -c 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install --lts && nvm use --lts && nvm alias default "lts/*"'

# VS Code
echo "🖊 Installing VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code
rm microsoft.gpg

# Install VS Code extensions (Laravel/Node/etc.)
echo "🧩 Installing VS Code Extensions..."
echo "⚠️  Note: VS Code extensions will be available after first launch"
# Create extensions list for user to install manually or via script later
cat > ~/vscode-extensions.txt << EOF
onecentlin.laravel-blade
bmewburn.vscode-intelephense-client
xdebug.php-debug
formulahendry.auto-close-tag
dbaeumer.vscode-eslint
ms-python.python
esbenp.prettier-vscode
EOF
echo "📝 VS Code extensions list saved to ~/vscode-extensions.txt"

# Postman (via snap)
echo "📮 Installing Postman..."
sudo snap install postman

# MySQL Workbench
echo "🛢 Installing MySQL Workbench..."
sudo apt install -y mysql-workbench

# HeidiSQL (via Wine)
echo "🍷 Installing Wine & HeidiSQL..."
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine64 wine32 winetricks
# Configure wine
sudo -u $SUDO_USER bash -c 'winecfg' 2>/dev/null || echo "Wine configuration skipped (no display)"
wget https://www.heidisql.com/downloads/releases/HeidiSQL_12.7_64_Portable.zip -O /tmp/HeidiSQL.zip
sudo -u $SUDO_USER unzip /tmp/HeidiSQL.zip -d "$HOME/HeidiSQL"
rm /tmp/HeidiSQL.zip
echo "✅ HeidiSQL installed under ~/HeidiSQL (Run with: wine ~/HeidiSQL/heidisql.exe)"

# Firefox Developer Edition
echo "🦊 Installing Firefox Developer Edition..."
wget -O firefox-dev.tar.bz2 "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
sudo tar xjf firefox-dev.tar.bz2 -C /opt/
sudo ln -sf /opt/firefox/firefox /usr/local/bin/firefox-developer
rm firefox-dev.tar.bz2

# Discord
echo "💬 Installing Discord..."
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb
rm discord.deb

# Clone and Compose Docker Repos
echo "🐙 Cloning your Docker GitHub repos..."

REPO_BASE="$HOME/dev-tools"
REPOS=(
  "https://github.com/GHOST117s/postgres-docker.git"
  "https://github.com/GHOST117s/LAMP.git"
)

mkdir -p "$REPO_BASE"
cd "$REPO_BASE"

for REPO in "${REPOS[@]}"; do
  NAME=$(basename "$REPO" .git)
  if [ ! -d "$NAME" ]; then
    git clone "$REPO"
  fi
done

echo "🐳 Running docker-compose for all services..."
for DIR in "$REPO_BASE"/*; do
  if [ -f "$DIR/docker-compose.yml" ]; then
    echo "➡️ Starting $DIR"
    cd "$DIR"
    # Use docker compose (new syntax) instead of docker-compose
    docker compose pull
    docker compose up -d
  fi
done

echo "🎉 All done! 

📋 Next Steps:
1. Restart your terminal or run: source ~/.bashrc
2. Log out and back in for Docker group permissions
3. Install VS Code extensions: cat ~/vscode-extensions.txt
4. Configure Wine for HeidiSQL if needed

🚀 Your development environment is ready!"
