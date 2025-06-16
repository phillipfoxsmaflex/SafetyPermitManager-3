# SafetyPermitManager-3 - Installationsanleitung

## 📋 Systemanforderungen

### Mindestanforderungen
- **Betriebssystem:** Debian 12 (Bookworm) oder kompatibel
- **RAM:** 2 GB (4 GB empfohlen)
- **Festplatte:** 5 GB freier Speicher (10 GB empfohlen)
- **CPU:** 1 Core (2 Cores empfohlen)
- **Netzwerk:** Internetverbindung für Installation

### Unterstützte Systeme
- ✅ Debian 12 (Bookworm)
- ✅ Ubuntu 22.04 LTS (mit Anpassungen)
- ✅ Ubuntu 20.04 LTS (mit Anpassungen)
- ⚠️ Andere Linux-Distributionen (manuelle Anpassungen erforderlich)

### Voraussetzungen
- Benutzer mit sudo-Berechtigung
- Internetverbindung
- Grundkenntnisse der Linux-Kommandozeile

## 🚀 Schnellinstallation

### Ein-Befehl-Installation
```bash
curl -fsSL https://raw.githubusercontent.com/phillipfoxsmaflex/SafetyPermitManager-3/main/install-debian12.sh | bash
```

### Manuelle Installation
```bash
# 1. Repository klonen
git clone https://github.com/phillipfoxsmaflex/SafetyPermitManager-3.git
cd SafetyPermitManager-3

# 2. Installationsskript ausführen
chmod +x install-debian12.sh
./install-debian12.sh

# 3. Anwendung starten
npm run dev
```

## 📝 Detaillierte Installationsschritte

### Schritt 1: System vorbereiten
```bash
# System aktualisieren
sudo apt-get update && sudo apt-get upgrade -y

# Git installieren (falls nicht vorhanden)
sudo apt-get install -y git curl
```

### Schritt 2: Projekt herunterladen
```bash
# Repository klonen
git clone https://github.com/phillipfoxsmaflex/SafetyPermitManager-3.git
cd SafetyPermitManager-3

# Installationsskript prüfen
ls -la install-debian12.sh
```

### Schritt 3: Installation ausführen
```bash
# Script ausführbar machen
chmod +x install-debian12.sh

# Installation starten (als normaler Benutzer!)
./install-debian12.sh
```

**Installationsdauer:** 5-10 Minuten

### Schritt 4: Installation verifizieren
```bash
# Service-Status prüfen
sudo systemctl status safety-permit-manager

# Anwendung testen
curl http://localhost:5000
```

### Schritt 5: Erste Anmeldung
1. Browser öffnen: http://localhost:5000
2. Mit Admin-Benutzer anmelden:
   - **Username:** `admin`
   - **Passwort:** `password123`
3. System konfigurieren und Admin-Passwort ändern

## 🔧 Konfiguration

### Umgebungsvariablen (.env)
Die wichtigsten Einstellungen in der `.env`-Datei:

```env
# Datenbank
DATABASE_URL=postgresql://biggs_user:PASSWORT@localhost:5432/biggs_permits

# Sicherheit
SESSION_SECRET=IHR-64-ZEICHEN-SECRET

# Server
NODE_ENV=development
PORT=5000

# Uploads
MAX_FILE_SIZE=10485760
UPLOAD_PATH=./uploads
```

### Produktions-Konfiguration
Für den Produktionseinsatz ändern Sie:

```env
NODE_ENV=production
SECURE_COOKIES=true
COOKIE_DOMAIN=.ihredomain.com
```

## 🔒 Sicherheit

### Nach der Installation prüfen
- [ ] Starke Passwörter verwendet
- [ ] .env-Datei geschützt (chmod 600)
- [ ] PostgreSQL nur lokal erreichbar
- [ ] Firewall konfiguriert
- [ ] SSL/HTTPS eingerichtet (Produktion)

### Passwort-Sicherheit
```bash
# Sichere Passwörter generieren
openssl rand -base64 32  # Datenbank
openssl rand -base64 64  # Session-Secret
```

## 🔄 Wartung

### Backup erstellen
```bash
# Automatisches Backup
./backup.sh

# Manuelles Backup
pg_dump -h localhost -U biggs_user biggs_permits > backup.sql
```

### Updates
```bash
# System-Updates
sudo apt-get update && sudo apt-get upgrade -y

# Anwendung aktualisieren
git pull
npm install
npm run build
sudo systemctl restart safety-permit-manager
```

### Monitoring
```bash
# Service-Status
sudo systemctl status safety-permit-manager

# Logs anzeigen
sudo journalctl -u safety-permit-manager -f

# Systemressourcen
htop
df -h
```

## 🆘 Problemlösung

### Häufige Probleme

#### Installation schlägt fehl
```bash
# Berechtigungen prüfen
whoami  # Sollte NICHT root sein
sudo -v  # sudo-Berechtigung testen

# Detaillierte Ausgabe
bash -x ./install-debian12.sh
```

#### Anwendung startet nicht
```bash
# Logs prüfen
npm run dev  # Detaillierte Fehlermeldungen

# Datenbank testen
PGPASSWORD='PASSWORT' psql -h localhost -U biggs_user -d biggs_permits -c "SELECT 1;"

# Port prüfen
sudo netstat -tlnp | grep :5000
```

#### Datenbankprobleme
```bash
# PostgreSQL Status
sudo systemctl status postgresql

# Verbindung testen
sudo -u postgres psql -c "SELECT version();"

# Schema neu erstellen
npm run db:push
```

### Support-Informationen sammeln
```bash
# System-Info für Support
echo "=== System Info ===" > support.txt
uname -a >> support.txt
cat /etc/debian_version >> support.txt
node --version >> support.txt
npm --version >> support.txt
sudo systemctl status safety-permit-manager >> support.txt
sudo journalctl -u safety-permit-manager --since "1 hour ago" >> support.txt
```

## 📞 Hilfe und Support

### Dokumentation
- Vollständige Dokumentation: [README.md](README.md)
- API-Dokumentation: Im Projekt enthalten
- Troubleshooting: Siehe README.md

### Community
- GitHub Issues: Für Bugs und Feature-Requests
- Diskussionen: GitHub Discussions

### Kommerzielle Unterstützung
Für professionelle Installation und Support kontaktieren Sie das Entwicklungsteam.

---

**Hinweis:** Diese Anleitung ist spezifisch für Debian 12. Für andere Systeme können Anpassungen erforderlich sein.