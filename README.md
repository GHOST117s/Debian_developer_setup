# Debian Developer Setup

## Overview

This project provides a `.deb` package that installs a complete developer environment on Debian-based systems. With a single installation, you get all the essential tools for web, backend, and general development, plus utilities for database management, media, and communication.

## Features

- **Runs all your Docker images**: Automatically detects and runs Docker images if a `docker-compose.yml` file is present in your project directories.
- **Installs all major developer tools at once**.

## Included Tools

- **PHP 8.2** with Laravel extensions
- **Node.js (LTS)** via nvm
- **Python 3** with pip
- **Visual Studio Code**
- **VLC Media Player**
- **Postman**
- **MySQL Workbench**
- **HeidiSQL** (via Wine)
- **Firefox Developer Edition**
- **Discord**

## Installation

1. Download the latest `.deb` file from the [Releases](#) section.
2. Install using:
   ```bash
   sudo dpkg -i <filename>.deb
   sudo apt-get install -f
   ```
3. All tools will be installed and available from your applications menu or terminal.

## Usage

- After installation, you can start developing immediately.
- Place your projects with `docker-compose.yml` files in your workspace; the setup will help you run them with Docker.

## Requirements

- Debian-based OS (Debian, Ubuntu, etc.)
- Sudo/root access for installation

## Notes

- HeidiSQL is installed via Wine for compatibility.
- Node.js is managed via nvm for easy version switching.
- All tools are installed with default settings; you can customize them post-installation.

## License

**MIT**