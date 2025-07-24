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

# Fira Code Font (Programming Font with Ligatures)
echo "🔤 Installing Fira Code font..."
sudo apt install -y fonts-firacode
fc-cache -f -v
echo "✅ Fira Code font installed with programming ligatures"

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
sudo apt install -y php8.2 php8.2-cli php8.2-common php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-bcmath php8.2-gd php8.2-soap php8.2-intl php8.2-readline php8.2-redis

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
ms-vscode.vscode-json
bradlc.vscode-tailwindcss
ms-vscode-remote.remote-containers
gitpod.gitpod-desktop
EOF
echo "📝 VS Code extensions list saved to ~/vscode-extensions.txt"

# Create VS Code settings with Fira Code font
echo "⚙️  Creating VS Code settings with Fira Code..."
mkdir -p ~/.config/Code/User
cat > ~/.config/Code/User/settings.json << EOF
{
    "editor.fontFamily": "'Fira Code', 'Droid Sans Mono', 'monospace', monospace",
    "editor.fontLigatures": true,
    "editor.fontSize": 14,
    "editor.lineHeight": 1.5,
    "terminal.integrated.fontFamily": "'Fira Code', monospace",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true
    },
    "workbench.iconTheme": "material-icon-theme",
    "editor.minimap.enabled": true,
    "git.enableSmartCommit": true,
    "git.confirmSync": false
}
EOF
echo "📝 VS Code configured with Fira Code font and ligatures"

# Postman (via snap)
echo "📮 Installing Postman..."
sudo snap install postman

# MySQL Workbench
echo "🛢 Installing MySQL Workbench..."
sudo apt install -y mysql-workbench

# Redis
echo "🔴 Installing Redis Server..."
sudo apt install -y redis-server
sudo systemctl enable redis-server
sudo systemctl start redis-server
echo "✅ Redis installed and started (Port: 6379)"

# Verify PHP Redis extension
echo "🔍 Verifying PHP Redis extension..."
if php -m | grep -q redis; then
    echo "✅ PHP Redis extension loaded successfully"
else
    echo "⚠️  PHP Redis extension not found - you may need to restart PHP services"
fi

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

# Additional Development Tools
echo "🛠️  Installing additional development tools..."

# DBeaver (Universal Database Tool)
echo "🗄️  Installing DBeaver..."
wget -O dbeaver.deb "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
sudo apt install -y ./dbeaver.deb
rm dbeaver.deb

# Git GUI tools
echo "🌳 Installing Git GUI tools..."
sudo apt install -y gitg git-cola

# Oh My Zsh (Enhanced terminal)
echo "🐚 Installing Oh My Zsh..."
sudo -u $SUDO_USER bash -c 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
sudo -u $SUDO_USER bash -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
sudo -u $SUDO_USER bash -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'

# Insomnia (REST API Client - Alternative to Postman)
echo "😴 Installing Insomnia..."
curl -1sLf 'https://dl.cloudsmith.io/public/insomnia/core/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/insomnia.gpg
echo "deb [signed-by=/usr/share/keyrings/insomnia.gpg arch=amd64] https://dl.cloudsmith.io/public/insomnia/core/deb/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/insomnia.list
sudo apt update
sudo apt install -y insomnia

# Terminator (Advanced Terminal)
echo "🖥️  Installing Terminator..."
sudo apt install -y terminator

# Spotify (Music Streaming)
echo "🎵 Installing Spotify..."
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install -y spotify-client

echo "✅ Additional development tools installed!"

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
