# SafetyPermitManager-3 - Digital Permit Management System

Ein umfassendes Arbeitserlaubnis-Management-System für die chemische Industrie mit AI-gestützter Sicherheitsanalyse und vollständiger TRBS-konformer Gefährdungsbeurteilung.

> **🚀 Schnellstart:** Für eine sofortige Installation siehe [QUICKSTART.md](QUICKSTART.md)  
> **📋 Detaillierte Installation:** Siehe [INSTALLATION.md](INSTALLATION.md)

## 🚀 Hauptfunktionen

### Permit Management
- **6 Permit-Typen**: Heißarbeiten, enge Räume, elektrische Arbeiten, Arbeiten in der Höhe, Chemikalienarbeiten, allgemeine Erlaubnisscheine
- **Vollständiger Workflow**: Entwurf → Genehmigung → Aktiv → Abgeschlossen
- **Rollenbasierte Genehmigungen**: Abteilungsleiter, Sicherheitsbeauftragte, Technik-Genehmiger
- **Dokumentenanhänge**: Datei-Uploads mit Metadaten und Downloadfunktion
- **Druckansicht**: Professionelle Arbeitserlaubnis-Ausgabe

### TRBS-konforme Sicherheitsbewertung
- **Vollständige 11 TRBS-Kategorien** (Mechanische, Elektrische, Gefahrstoffe, Biologische, Brand/Explosion, Thermische, Physikalische, Arbeitsumgebung, Physische Belastung, Psychische Faktoren, Sonstige)
- **48 spezifische Gefährdungen** mit strukturierter Risikoanalyse
- **Detaillierte Gefährdungsnotizen** mit JSON-strukturierter Speicherung
- **Schutzmaßnahmen-Tracking** mit vordefiniertem Katalog
- **Compliance-Felder**: Sofortmaßnahmen, Vorbereitung, Compliance-Hinweise

### AI-gestützte Verbesserungsvorschläge
- **Webhook-Integration** für externe AI-Services mit vollständiger TRBS-Datenübertragung
- **Feldspezifische Suggestions** mit Begründung und Priorität
- **Manuelle Genehmigung** aller AI-Vorschläge
- **TRBS-Mapping** für automatische Gefährdungserkennung
- **Batch-Operationen**: Alle annehmen/ablehnen/löschen

### Benutzerverwaltung
- **5 Benutzerrollen**: Admin, Anforderer, Sicherheitsbeauftragte, Abteilungsleiter, Technik
- **Session-basierte Authentifizierung** mit sicherer Speicherung
- **Rollenbasierte Berechtigungen** für alle Funktionen

## 🛠 Technische Architektur

### Frontend
- **React.js + TypeScript** mit Wouter Router
- **Shadcn/ui** für UI-Komponenten
- **TanStack Query** für State Management
- **React Hook Form** mit Zod-Validierung
- **Tailwind CSS** für responsives Design

### Backend
- **Express.js** mit TypeScript
- **PostgreSQL** Datenbank mit Drizzle ORM
- **Session-Management** mit sicherer Speicherung
- **Multer** für Datei-Upload Handling

### AI Integration
- **Webhook-basiert** für flexible AI-Provider
- **Vollständige TRBS-Datenübertragung** aller 11 Kategorien
- **Strukturierte JSON-Responses** mit Error Handling

## 📋 Installation & Setup

### 🚀 Automatisierte Installation für Debian 12 (Empfohlen)

Das vollautomatische Installationsskript richtet das komplette System in wenigen Minuten ein:

```bash
# Repository klonen
git clone https://github.com/phillipfoxsmaflex/SafetyPermitManager-3.git
cd SafetyPermitManager-3

# Vollständige Installation ausführen
chmod +x install-debian12.sh
./install-debian12.sh
```

**Das Installationsskript führt automatisch aus:**
- ✅ System-Updates und Abhängigkeiten
- ✅ Node.js 18+ Installation
- ✅ PostgreSQL Installation und Konfiguration
- ✅ Datenbank und Benutzer-Erstellung
- ✅ Sichere Passwort-Generierung
- ✅ npm-Abhängigkeiten Installation
- ✅ Datenbank-Schema Initialisierung
- ✅ Admin-Benutzer Erstellung (admin/password123)
- ✅ .env-Datei mit sicheren Einstellungen
- ✅ systemd Service-Konfiguration
- ✅ Backup-Script Erstellung
- ✅ Vollständige Funktionsprüfung

### 📋 Schritt-für-Schritt Installationsanleitung

#### Schritt 1: System vorbereiten
```bash
# Als normaler Benutzer (NICHT als root!)
# Stellen Sie sicher, dass Sie sudo-Berechtigung haben
sudo apt-get update
```

#### Schritt 2: Repository klonen
```bash
# Projekt herunterladen
git clone https://github.com/phillipfoxsmaflex/SafetyPermitManager-3.git
cd SafetyPermitManager-3

# Installationsskript ausführbar machen
chmod +x install-debian12.sh
```

#### Schritt 3: Installation starten
```bash
# Vollautomatische Installation
./install-debian12.sh
```

**Installationsdauer:** ca. 5-10 Minuten (abhängig von der Internetverbindung)

#### Schritt 4: Anwendung starten

**Development-Modus:**
```bash
npm run dev
```

**Production-Modus:**
```bash
# Service starten
sudo systemctl start safety-permit-manager

# Service-Status prüfen
sudo systemctl status safety-permit-manager

# Logs anzeigen
sudo journalctl -u safety-permit-manager -f
```

#### Schritt 5: Erste Anmeldung
1. Öffnen Sie http://localhost:5000 im Browser
2. Melden Sie sich mit dem automatisch erstellten Admin-Benutzer an:
   - **Username:** `admin`
   - **Passwort:** `password123`
3. Konfigurieren Sie das System und ändern Sie das Admin-Passwort

### 🔧 Manuelle Installation (für Experten)

Falls Sie die Installation manuell durchführen möchten:

#### System-Abhängigkeiten installieren
```bash
# Node.js 18+ installieren
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# PostgreSQL installieren
sudo apt-get install -y postgresql postgresql-contrib

# Weitere Abhängigkeiten
sudo apt-get install -y build-essential git openssl
```

#### PostgreSQL konfigurieren
```bash
# PostgreSQL starten
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Datenbank und Benutzer erstellen
sudo -u postgres psql
```

```sql
-- In der PostgreSQL Shell:
CREATE DATABASE biggs_permits;
CREATE USER biggs_user WITH PASSWORD 'IhrSicheresPasswort123!';
GRANT ALL PRIVILEGES ON DATABASE biggs_permits TO biggs_user;
ALTER USER biggs_user CREATEDB;

-- Verbindung zur Datenbank
\c biggs_permits

-- Schema-Berechtigungen
GRANT ALL ON SCHEMA public TO biggs_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO biggs_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO biggs_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO biggs_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO biggs_user;

\q
```

#### Projekt konfigurieren
```bash
# npm-Abhängigkeiten installieren
npm install

# Umgebungsvariablen konfigurieren
cp .env.example .env
nano .env  # Bearbeiten Sie die Datei mit Ihren Einstellungen
```

#### .env-Datei konfigurieren
```env
# Wichtige Einstellungen in .env:
DATABASE_URL=postgresql://biggs_user:IhrSicheresPasswort123!@localhost:5432/biggs_permits
SESSION_SECRET=IhrSehr-Langes-Und-Sicheres-Session-Secret-Mit-64-Zeichen
NODE_ENV=development
PORT=5000
```

#### Datenbank initialisieren
```bash
# Schema erstellen
npm run db:push

# Optional: Beispieldaten laden
npx tsx server/seed.ts
```

#### Anwendung bauen und starten
```bash
# Für Development
npm run dev

# Für Production
npm run build
npm start
```

### 🔐 Wichtige Sicherheitshinweise

#### Nach der Installation prüfen:
- [ ] Starke Datenbank-Passwörter verwendet
- [ ] Session-Secret ist mindestens 64 Zeichen lang
- [ ] .env-Datei hat korrekte Berechtigungen (600)
- [ ] PostgreSQL ist nur lokal erreichbar
- [ ] Firewall ist konfiguriert

#### Passwort-Sicherheit:
```bash
# Sichere Passwörter generieren:
openssl rand -base64 32  # Für Datenbank-Passwort
openssl rand -base64 64  # Für Session-Secret
```

### 📁 Wichtige Dateien und Verzeichnisse

Nach der Installation finden Sie:
```
SafetyPermitManager-3/
├── .env                    # Konfigurationsdatei (VERTRAULICH!)
├── install-debian12.sh     # Installationsskript
├── backup.sh              # Backup-Script
├── uploads/               # Datei-Uploads
├── logs/                  # Log-Dateien
├── backups/               # Backup-Verzeichnis
├── dist/                  # Gebaute Anwendung
└── node_modules/          # npm-Abhängigkeiten
```

### 🔄 Backup und Wartung

#### Automatisches Backup erstellen:
```bash
# Backup-Script ausführen
./backup.sh

# Automatisches tägliches Backup einrichten
echo "0 2 * * * cd $(pwd) && ./backup.sh" | crontab -
```

#### System-Wartung:
```bash
# Service-Status prüfen
sudo systemctl status safety-permit-manager

# Logs anzeigen
sudo journalctl -u safety-permit-manager -f

# Service neu starten
sudo systemctl restart safety-permit-manager

# Datenbank-Verbindung testen
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "SELECT version();"
```

## 🔌 AI-Integration

### TRBS-Webhook-System
Das System sendet vollständige TRBS-Gefährdungsdaten zur AI-Analyse:

**Outbound (System → AI)**
```json
POST https://your-ai-service.com/analyze
{
  "action": "analyze_permit",
  "permitData": {
    "permitId": "HT-2025-001",
    "type": "hot_work",
    "trbsAssessment": {
      "selectedHazards": ["1-0", "2-0", "5-0"],
      "hazardNotes": {
        "1-0": "Quetschgefahr durch hydraulische Presse",
        "2-0": "Lichtbogenschweißen erforderlich",
        "5-0": "Tankinhalt explosionsfähig"
      },
      "completedMeasures": ["ppe_welding", "fire_watch"],
      "hazardCategories": [
        {
          "categoryId": 1,
          "categoryName": "Mechanische Gefährdungen",
          "selectedHazards": [...],
          "totalHazards": 4,
          "selectedCount": 1
        }
      ]
    }
  }
}
```

**Inbound (AI → System)**
```json
POST https://your-domain.com/api/webhooks/suggestions
{
  "permitId": "HT-2025-001", 
  "analysisComplete": true,
  "suggestions": [
    {
      "type": "trbs_hazard_enhancement",
      "priority": "high",
      "fieldName": "selectedHazards",
      "originalValue": ["5-0"],
      "suggestedValue": ["5-0", "5-1", "2-0", "7-2"],
      "reasoning": "Schweißarbeiten erfordern zusätzliche Kategorien: Hautkontakt (5-1), Brandgefahr (2-0), UV-Strahlung (7-2)"
    }
  ]
}
```

### Vollständige TRBS-Kategorien
Das System implementiert alle 11 TRBS-Standardkategorien:

1. **Mechanische Gefährdungen** (4 Unterkategorien)
2. **Elektrische Gefährdungen** (4 Unterkategorien)
3. **Gefahrstoffe** (4 Unterkategorien)
4. **Biologische Arbeitsstoffe** (3 Unterkategorien)
5. **Brand- und Explosionsgefährdungen** (3 Unterkategorien)
6. **Thermische Gefährdungen** (3 Unterkategorien)
7. **Spezielle physikalische Einwirkungen** (8 Unterkategorien)
8. **Arbeitsumgebungsbedingungen** (6 Unterkategorien)
9. **Physische Belastung/Arbeitsschwere** (5 Unterkategorien)
10. **Psychische Faktoren** (4 Unterkategorien)
11. **Sonstige Gefährdungen** (4 Unterkategorien)

## 📝 API-Endpunkte

### Permits
- `GET /api/permits` - Alle Permits abrufen
- `GET /api/permits/:id` - Einzelnes Permit abrufen
- `POST /api/permits` - Neues Permit erstellen
- `PATCH /api/permits/:id` - Permit aktualisieren
- `DELETE /api/permits/:id` - Permit löschen

### AI-Suggestions
- `GET /api/permits/:id/suggestions` - Alle Suggestions eines Permits
- `POST /api/webhooks/suggestions` - AI-Suggestions empfangen
- `POST /api/permits/:id/apply-all-suggestions` - Alle Suggestions anwenden
- `PATCH /api/suggestions/:id/apply` - Einzelne Suggestion anwenden
- `DELETE /api/suggestions/:id` - Suggestion löschen

### Benutzer & Rollen
- `GET /api/users/department-heads` - Abteilungsleiter
- `GET /api/users/safety-officers` - Sicherheitsbeauftragte  
- `GET /api/users/maintenance-approvers` - Technik-Genehmiger
- `GET /api/work-locations/active` - Aktive Arbeitsorte

### Anhänge
- `GET /api/permits/:id/attachments` - Permit-Anhänge
- `POST /api/permits/:id/attachments` - Datei hochladen
- `DELETE /api/attachments/:id` - Anhang löschen

## 🎯 Benutzerrollen

### Administrator
- Vollzugriff auf alle Funktionen
- Benutzerverwaltung und System-Konfiguration
- Permit-Löschung und Datenbank-Verwaltung

### Anforderer  
- Permits erstellen und bearbeiten
- Eigene Permits verwalten
- AI-Suggestions verwenden

### Sicherheitsbeauftragte
- Permits genehmigen/ablehnen
- TRBS-konforme Sicherheitsbewertungen
- Gefährdungsbeurteilungen durchführen

### Abteilungsleiter
- Departmental Permits genehmigen
- Team-Permit-Übersicht
- Ressourcen-Genehmigungen

### Technik
- Technische Genehmigungen
- Wartungs-Permits und Equipment-Freigaben

## 🚀 Produktions-Deployment

### Umgebungskonfiguration
```env
NODE_ENV=production
DATABASE_URL=postgresql://user:pass@prod-host:5432/biggs_prod
SESSION_SECRET=your-very-secure-64-character-secret
SECURE_COOKIES=true
COOKIE_DOMAIN=.yourdomain.com
```

### PM2 Prozess-Management
```bash
npm install -g pm2

# PM2 Konfiguration
cat > ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: 'biggs-permits',
    script: 'dist/index.js',
    instances: 'max',
    exec_mode: 'cluster',
    env_production: {
      NODE_ENV: 'production'
    }
  }]
}
EOF

# Starten
pm2 start ecosystem.config.js --env production
pm2 save && pm2 startup
```

### Nginx Konfiguration
```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    client_max_body_size 10M;
}
```

### SSL mit Certbot
```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com

# Auto-renewal
echo "0 12 * * * /usr/bin/certbot renew --quiet" | sudo crontab -
```

## 📊 Datenbank-Management

### Backup & Restore
```bash
# Backup erstellen
pg_dump -h localhost -U biggs_user -d biggs_permits > backup_$(date +%Y%m%d_%H%M%S).sql

# Automatisches tägliches Backup
echo "0 2 * * * pg_dump -h localhost -U biggs_user -d biggs_permits > /backup/biggs_$(date +\%Y\%m\%d).sql" | crontab -

# Restore
psql -h localhost -U biggs_user -d biggs_permits < backup_file.sql
```

### Schema-Updates
```bash
# Migration generieren
npm run db:generate

# Migration anwenden
npm run db:push
```

## 🔒 Sicherheits-Checkliste

### Pre-Production
- [ ] Starke Datenbank-Passwörter (20+ Zeichen)
- [ ] Sicheres Session-Secret (64+ Zeichen)
- [ ] HTTPS mit gültigen Zertifikaten
- [ ] Sichere Cookies aktiviert
- [ ] Datenbank-Firewall konfiguriert
- [ ] Regelmäßige Backups geplant
- [ ] Log-Monitoring aktiviert
- [ ] File-Upload-Limits konfiguriert

### Post-Deployment
- [ ] Standard Admin-Passwort geändert
- [ ] Test-Benutzerkonten entfernt
- [ ] Security-Header konfiguriert
- [ ] Datenbank-Zugriff geprüft
- [ ] Backup-Restore getestet
- [ ] Monitoring-Alerts konfiguriert
- [ ] SSL-Zertifikat Auto-Renewal getestet

## ⚡ Schnellstart-Anleitung

Für erfahrene Benutzer - Installation in 3 Befehlen:

```bash
git clone https://github.com/phillipfoxsmaflex/SafetyPermitManager-3.git
cd SafetyPermitManager-3
./install-debian12.sh && npm run dev
```

Nach der Installation: http://localhost:5000 öffnen und Admin-Benutzer erstellen.

## 🔧 Troubleshooting & Fehlerbehebung

### 🚨 Häufige Installationsprobleme

#### 1. **Installationsskript schlägt fehl**
```bash
# Prüfen Sie die Berechtigung
ls -la install-debian12.sh

# Script ausführbar machen
chmod +x install-debian12.sh

# Als normaler Benutzer ausführen (NICHT als root)
whoami  # Sollte NICHT "root" anzeigen

# Detaillierte Ausgabe aktivieren
bash -x ./install-debian12.sh
```

#### 2. **Node.js Installation fehlgeschlagen**
```bash
# Manuelle Node.js Installation
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Version prüfen
node --version  # Sollte v18.x.x oder höher sein
npm --version
```

#### 3. **PostgreSQL Verbindungsfehler**
```bash
# PostgreSQL Status prüfen
sudo systemctl status postgresql

# PostgreSQL starten falls gestoppt
sudo systemctl start postgresql

# Verbindung testen
sudo -u postgres psql -c "SELECT version();"

# Benutzer und Datenbank prüfen
sudo -u postgres psql -c "\du"  # Benutzer anzeigen
sudo -u postgres psql -c "\l"   # Datenbanken anzeigen
```

#### 4. **npm Installation Fehler**
```bash
# npm Cache leeren
npm cache clean --force

# node_modules löschen und neu installieren
rm -rf node_modules package-lock.json
npm install

# Bei Berechtigungsfehlern
sudo chown -R $(whoami) ~/.npm
```

### 🔍 Laufzeit-Probleme diagnostizieren

#### 1. **Anwendung startet nicht**
```bash
# .env Datei prüfen
cat .env | grep -E "(DATABASE_URL|SESSION_SECRET|PORT)"

# Datenbankverbindung testen
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "SELECT 1;"

# Port-Konflikte prüfen
sudo netstat -tlnp | grep :5000

# Logs anzeigen
npm run dev  # Für detaillierte Fehlermeldungen
```

#### 2. **Datenbankfehler**
```bash
# Datenbank-Schema prüfen
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "\dt"

# Schema neu erstellen
npm run db:push

# Datenbank-Logs prüfen
sudo tail -f /var/log/postgresql/postgresql-*.log
```

#### 3. **Session/Login-Probleme**
```bash
# Session-Secret prüfen
grep SESSION_SECRET .env

# Browser-Cache und Cookies löschen
# Oder Inkognito-Modus verwenden

# Cookie-Domain prüfen
grep COOKIE_DOMAIN .env
```

#### 4. **File-Upload Fehler**
```bash
# Upload-Verzeichnis prüfen
ls -la uploads/
mkdir -p uploads
chmod 755 uploads

# Festplattenspeicher prüfen
df -h

# Dateigrößen-Limit prüfen
grep MAX_FILE_SIZE .env
```

### 📊 System-Monitoring

#### Service-Status überwachen
```bash
# Service-Status
sudo systemctl status safety-permit-manager

# Service-Logs in Echtzeit
sudo journalctl -u safety-permit-manager -f

# Service neu starten
sudo systemctl restart safety-permit-manager

# Service-Konfiguration prüfen
sudo systemctl cat safety-permit-manager
```

#### Performance-Monitoring
```bash
# Systemressourcen
htop
free -h
df -h

# Netzwerk-Verbindungen
sudo netstat -tlnp | grep node

# Prozess-Details
ps aux | grep node
```

#### Datenbank-Performance
```bash
# Aktive Verbindungen
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "SELECT count(*) FROM pg_stat_activity;"

# Datenbank-Größe
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "SELECT pg_size_pretty(pg_database_size('biggs_permits'));"

# Tabellen-Größen
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "SELECT schemaname,tablename,pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size FROM pg_tables WHERE schemaname='public' ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;"
```

### 🔧 Wartung und Updates

#### Regelmäßige Wartung
```bash
# System-Updates
sudo apt-get update && sudo apt-get upgrade -y

# npm-Abhängigkeiten aktualisieren
npm update

# Datenbank-Wartung
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "VACUUM ANALYZE;"

# Log-Rotation
sudo logrotate -f /etc/logrotate.conf
```

#### Backup-Verifikation
```bash
# Backup erstellen
./backup.sh

# Backup-Integrität prüfen
ls -la backups/
pg_dump --version

# Restore-Test (auf Testsystem)
# PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d test_db < backups/db_backup_YYYYMMDD_HHMMSS.sql
```

### 🆘 Notfall-Wiederherstellung

#### Bei kritischen Fehlern
```bash
# 1. Service stoppen
sudo systemctl stop safety-permit-manager

# 2. Backup wiederherstellen
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits < backups/latest_backup.sql

# 3. Konfiguration wiederherstellen
cp backups/env_backup_YYYYMMDD .env

# 4. Anwendung neu bauen
npm run build

# 5. Service starten
sudo systemctl start safety-permit-manager
```

#### Komplette Neuinstallation
```bash
# 1. Daten sichern
./backup.sh

# 2. Alte Installation entfernen
sudo systemctl stop safety-permit-manager
sudo systemctl disable safety-permit-manager
sudo rm /etc/systemd/system/safety-permit-manager.service

# 3. Neuinstallation
./install-debian12.sh

# 4. Daten wiederherstellen
# (Backup-Dateien manuell wiederherstellen)
```

### 📞 Support und Hilfe

#### Logs sammeln für Support
```bash
# System-Informationen sammeln
echo "=== System Info ===" > support_info.txt
uname -a >> support_info.txt
cat /etc/debian_version >> support_info.txt
node --version >> support_info.txt
npm --version >> support_info.txt

echo "=== Service Status ===" >> support_info.txt
sudo systemctl status safety-permit-manager >> support_info.txt

echo "=== Recent Logs ===" >> support_info.txt
sudo journalctl -u safety-permit-manager --since "1 hour ago" >> support_info.txt

echo "=== Database Status ===" >> support_info.txt
sudo systemctl status postgresql >> support_info.txt

# Datei an Support senden
```

#### Health-Check Script
```bash
# Erstellen Sie ein Health-Check Script
cat > health_check.sh << 'EOF'
#!/bin/bash
echo "=== SafetyPermitManager-3 Health Check ==="
echo "Datum: $(date)"
echo

# Service Status
echo "Service Status:"
sudo systemctl is-active safety-permit-manager

# Port Check
echo "Port 5000 Status:"
curl -s -o /dev/null -w "%{http_code}" http://localhost:5000 || echo "Nicht erreichbar"

# Database Check
echo "Datenbank Status:"
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "SELECT 1;" > /dev/null 2>&1 && echo "OK" || echo "Fehler"

# Disk Space
echo "Festplattenspeicher:"
df -h | grep -E "(/$|/var|/tmp)"

echo "=== Health Check Complete ==="
EOF

chmod +x health_check.sh
./health_check.sh
```

## 📄 Lizenz

Proprietäre Software für industrielle Arbeitserlaubnis-Verwaltung.

## 📞 Support

Für technischen Support und Implementierungsfragen kontaktieren Sie das Entwicklungsteam.