# SafetyPermitManager-3 - Dokumentationsübersicht

## 📚 Verfügbare Dokumentationen

### 🚀 Schnellstart
- **[QUICKSTART.md](QUICKSTART.md)** - Installation in 3 Schritten
- **[INSTALLATION.md](INSTALLATION.md)** - Detaillierte Installationsanleitung
- **[README.md](README.md)** - Vollständige Dokumentation

### 🛠 Scripts und Tools
- **[install-debian12.sh](install-debian12.sh)** - Automatisches Installationsskript
- **[health-check.sh](health-check.sh)** - System-Diagnose-Tool
- **[backup.sh](backup.sh)** - Backup-Script (wird bei Installation erstellt)

### ⚙️ Konfiguration
- **[.env.example](.env.example)** - Beispiel-Konfigurationsdatei
- **[package.json](package.json)** - npm-Abhängigkeiten und Scripts

## 🎯 Welche Dokumentation für wen?

### Für Einsteiger
1. **[QUICKSTART.md](QUICKSTART.md)** - Sofortiger Start
2. **[INSTALLATION.md](INSTALLATION.md)** - Wenn Sie Details benötigen

### Für Administratoren
1. **[README.md](README.md)** - Vollständige Referenz
2. **[health-check.sh](health-check.sh)** - Regelmäßige System-Checks

### Für Entwickler
1. **[README.md](README.md)** - API-Dokumentation und Architektur
2. **[package.json](package.json)** - Build-Scripts und Abhängigkeiten

## 🔧 Wichtige Befehle

### Installation
```bash
# Schnellinstallation
./install-debian12.sh

# System-Check
./health-check.sh
```

### Development
```bash
# Development-Server
npm run dev

# Build für Production
npm run build

# TypeScript-Check
npm run check
```

### Production
```bash
# Service-Management
sudo systemctl start safety-permit-manager
sudo systemctl status safety-permit-manager
sudo systemctl stop safety-permit-manager

# Logs anzeigen
sudo journalctl -u safety-permit-manager -f
```

### Wartung
```bash
# Backup erstellen
./backup.sh

# Datenbank-Wartung
npm run db:push

# System-Updates
sudo apt-get update && sudo apt-get upgrade -y
```

## 📋 Systemanforderungen

- **OS:** Debian 12 (Bookworm)
- **RAM:** 2 GB (4 GB empfohlen)
- **Disk:** 5 GB (10 GB empfohlen)
- **CPU:** 1 Core (2 Cores empfohlen)

## 🔗 Wichtige Links

- **Anwendung:** http://localhost:5000 (nach Installation)
- **GitHub:** https://github.com/phillipfoxsmaflex/SafetyPermitManager-3
- **Issues:** https://github.com/phillipfoxsmaflex/SafetyPermitManager-3/issues

## 🆘 Support

### Selbsthilfe
1. **[health-check.sh](health-check.sh)** ausführen
2. **[README.md](README.md)** Troubleshooting-Sektion lesen
3. Logs prüfen: `sudo journalctl -u safety-permit-manager -f`

### Community-Support
- GitHub Issues für Bugs
- GitHub Discussions für Fragen

### Kommerzielle Unterstützung
Kontaktieren Sie das Entwicklungsteam für professionelle Installation und Support.

---

**Tipp:** Beginnen Sie mit [QUICKSTART.md](QUICKSTART.md) für eine sofortige Installation!