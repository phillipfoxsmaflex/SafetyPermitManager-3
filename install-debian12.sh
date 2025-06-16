#!/bin/bash

# SafetyPermitManager-3 Installation Script für Debian 12
# Dieses Script installiert alle notwendigen Abhängigkeiten und konfiguriert die Anwendung

set -e  # Exit bei Fehlern

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging Funktionen
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Prüfe ob Script als root ausgeführt wird
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "Dieses Script sollte NICHT als root ausgeführt werden!"
        log_info "Führen Sie es als normaler Benutzer aus. sudo wird bei Bedarf automatisch verwendet."
        exit 1
    fi
}

# Prüfe Debian Version
check_debian_version() {
    if [[ ! -f /etc/debian_version ]]; then
        log_error "Dieses System scheint kein Debian zu sein!"
        exit 1
    fi
    
    DEBIAN_VERSION=$(cat /etc/debian_version | cut -d. -f1)
    if [[ $DEBIAN_VERSION -lt 12 ]]; then
        log_warning "Dieses Script ist für Debian 12 optimiert. Ihre Version: $(cat /etc/debian_version)"
        read -p "Möchten Sie trotzdem fortfahren? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# System Updates
update_system() {
    log_info "Aktualisiere System-Pakete..."
    sudo apt-get update
    sudo apt-get upgrade -y
    log_success "System erfolgreich aktualisiert"
}

# Installiere System-Abhängigkeiten
install_system_dependencies() {
    log_info "Installiere System-Abhängigkeiten..."
    
    sudo apt-get install -y \
        curl \
        wget \
        gnupg \
        lsb-release \
        ca-certificates \
        apt-transport-https \
        software-properties-common \
        build-essential \
        git \
        unzip \
        openssl \
        systemd
    
    log_success "System-Abhängigkeiten installiert"
}

# Installiere Node.js 18+
install_nodejs() {
    log_info "Installiere Node.js 18..."
    
    # Prüfe ob Node.js bereits installiert ist
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        if [[ $NODE_VERSION -ge 18 ]]; then
            log_success "Node.js $NODE_VERSION bereits installiert"
            return
        else
            log_warning "Node.js Version $NODE_VERSION ist zu alt. Installiere Version 18..."
        fi
    fi
    
    # NodeSource Repository hinzufügen
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    
    # Node.js installieren
    sudo apt-get install -y nodejs
    
    # Version prüfen
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    
    log_success "Node.js $NODE_VERSION und npm $NPM_VERSION installiert"
}

# Installiere PostgreSQL
install_postgresql() {
    log_info "Installiere PostgreSQL..."
    
    # Prüfe ob PostgreSQL bereits installiert ist
    if command -v psql &> /dev/null; then
        log_success "PostgreSQL bereits installiert"
        return
    fi
    
    # PostgreSQL installieren
    sudo apt-get install -y postgresql postgresql-contrib
    
    # PostgreSQL starten und aktivieren
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    
    log_success "PostgreSQL installiert und gestartet"
}

# Generiere sichere Passwörter
generate_passwords() {
    log_info "Generiere sichere Passwörter..."
    
    # Datenbank Passwort (20 Zeichen)
    DB_PASSWORD=$(openssl rand -base64 15 | tr -d "=+/" | cut -c1-20)
    
    # Session Secret (64 Zeichen)
    SESSION_SECRET=$(openssl rand -base64 48 | tr -d "=+/" | cut -c1-64)
    
    log_success "Sichere Passwörter generiert"
}

# Konfiguriere PostgreSQL Datenbank
setup_database() {
    log_info "Konfiguriere PostgreSQL Datenbank..."
    
    # Datenbank und Benutzer erstellen
    sudo -u postgres psql << EOF
-- Erstelle Datenbank
DROP DATABASE IF EXISTS biggs_permits;
CREATE DATABASE biggs_permits;

-- Erstelle Benutzer
DROP USER IF EXISTS biggs_user;
CREATE USER biggs_user WITH PASSWORD '$DB_PASSWORD';

-- Vergebe Berechtigungen
GRANT ALL PRIVILEGES ON DATABASE biggs_permits TO biggs_user;
ALTER USER biggs_user CREATEDB;

-- Verbindung zur Datenbank
\c biggs_permits

-- Vergebe Schema-Berechtigungen
GRANT ALL ON SCHEMA public TO biggs_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO biggs_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO biggs_user;

-- Setze Default-Berechtigungen
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO biggs_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO biggs_user;

\q
EOF
    
    log_success "Datenbank 'biggs_permits' und Benutzer 'biggs_user' erstellt"
}

# Installiere npm Abhängigkeiten
install_npm_dependencies() {
    log_info "Installiere npm Abhängigkeiten..."
    
    # Prüfe ob package.json existiert
    if [[ ! -f "package.json" ]]; then
        log_error "package.json nicht gefunden! Sind Sie im richtigen Verzeichnis?"
        exit 1
    fi
    
    # npm cache leeren (falls vorhanden)
    npm cache clean --force 2>/dev/null || true
    
    # Alte Build-Dateien löschen
    rm -rf dist node_modules/.cache 2>/dev/null || true
    
    # Abhängigkeiten installieren
    npm install
    
    log_success "npm Abhängigkeiten installiert"
}

# Erstelle .env Datei
create_env_file() {
    log_info "Erstelle .env Konfigurationsdatei..."
    
    # Backup der existierenden .env falls vorhanden
    if [[ -f ".env" ]]; then
        cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
        log_warning "Existierende .env wurde gesichert"
    fi
    
    # .env Datei erstellen
    cat > .env << EOF
# SafetyPermitManager-3 - Automatisch generierte Konfiguration
# Generiert am: $(date)

# ===========================================
# DATABASE CONFIGURATION
# ===========================================
DATABASE_URL=postgresql://biggs_user:$DB_PASSWORD@localhost:5432/biggs_permits

# Individual database connection parameters
PGUSER=biggs_user
PGPASSWORD=$DB_PASSWORD
PGHOST=localhost
PGPORT=5432
PGDATABASE=biggs_permits

# ===========================================
# SESSION & SECURITY
# ===========================================
SESSION_SECRET=$SESSION_SECRET

# ===========================================
# SERVER CONFIGURATION
# ===========================================
NODE_ENV=development
PORT=5000
COOKIE_DOMAIN=localhost
SECURE_COOKIES=false

# ===========================================
# FILE UPLOAD CONFIGURATION
# ===========================================
MAX_FILE_SIZE=10485760
UPLOAD_PATH=./uploads
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/gif,application/pdf,text/plain,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet

# ===========================================
# LOGGING & MONITORING
# ===========================================
LOG_LEVEL=info
REQUEST_LOGGING=true

# ===========================================
# AI INTEGRATION (OPTIONAL)
# ===========================================
# WEBHOOK_URL=https://your-ai-service.com/webhook
# AI_TIMEOUT=30000
EOF
    
    # Sichere Berechtigungen für .env Datei setzen
    chmod 600 .env
    
    log_success ".env Datei erstellt"
}

# Erstelle notwendige Verzeichnisse
create_directories() {
    log_info "Erstelle notwendige Verzeichnisse..."
    
    # Upload-Verzeichnis
    mkdir -p uploads
    chmod 755 uploads
    
    # Logs-Verzeichnis
    mkdir -p logs
    chmod 755 logs
    
    # Backup-Verzeichnis
    mkdir -p backups
    chmod 755 backups
    
    log_success "Verzeichnisse erstellt"
}

# Initialisiere Datenbank Schema
initialize_database() {
    log_info "Initialisiere Datenbank Schema..."
    
    # Drizzle Schema pushen
    npm run db:push
    
    # Seede Datenbank mit Standard-Benutzern
    log_info "Erstelle Standard-Benutzer und Beispieldaten..."
    
    # Prüfe ob .env Datei existiert
    if [[ ! -f ".env" ]]; then
        log_error ".env Datei nicht gefunden! Seeding wird übersprungen."
        log_info "Sie können das Seeding später manuell ausführen mit: npx tsx server/seed.ts"
        return 1
    fi
    
    # Führe Seeding aus
    if npx tsx server/seed.ts; then
        log_success "Standard-Benutzer erfolgreich erstellt"
    else
        log_error "Seeding fehlgeschlagen. Sie können es später manuell ausführen:"
        log_info "  cd /opt/SafetyPermitManager-3"
        log_info "  npx tsx server/seed.ts"
    fi
    
    log_success "Datenbank Schema initialisiert und geseedet"
}

# Erstelle Admin-Benutzer
create_admin_user() {
    log_info "Erstelle Admin-Benutzer..."
    
    # SQL-Script für Admin-Benutzer erstellen
    cat > create_admin.sql << EOF
-- Erstelle Admin-Benutzer falls nicht vorhanden
INSERT INTO users (username, password, full_name, department, role)
VALUES ('admin', 'password123', 'System Administrator', 'IT', 'admin')
ON CONFLICT (username) DO NOTHING;

-- Erstelle Standard-Arbeitsplätze
INSERT INTO work_locations (name, description, building, area, is_active)
VALUES 
    ('Produktionshalle A', 'Hauptproduktionshalle für chemische Verfahren', 'Gebäude A', 'Produktion', true),
    ('Produktionshalle B', 'Sekundäre Produktionshalle', 'Gebäude B', 'Produktion', true),
    ('Lagerhalle C', 'Chemikalienlager und Rohstofflager', 'Gebäude C', 'Lager', true),
    ('Wartungsbereich', 'Zentrale Wartungswerkstatt', 'Gebäude D', 'Wartung', true),
    ('Außenbereich Nord', 'Außenanlagen und Tanks', 'Außenbereich', 'Tanks', true),
    ('Labor', 'Qualitätskontrolle und Analytik', 'Gebäude E', 'Labor', true)
ON CONFLICT (name) DO NOTHING;

-- Erstelle System-Einstellungen
INSERT INTO system_settings (application_title)
VALUES ('SafetyPermitManager-3')
ON CONFLICT (id) DO NOTHING;
EOF

    # Admin-Benutzer in Datenbank erstellen
    PGPASSWORD="$DB_PASSWORD" psql -h localhost -U biggs_user -d biggs_permits -f create_admin.sql
    
    # Temporäre SQL-Datei löschen
    rm create_admin.sql
    
    log_success "Admin-Benutzer erstellt (Username: admin, Passwort: password123)"
}

# Baue die Anwendung
build_application() {
    log_info "Baue die Anwendung..."
    
    # TypeScript kompilieren und Vite build
    npm run build
    
    log_success "Anwendung erfolgreich gebaut"
}

# Installiere Anwendung nach /opt
install_to_opt() {
    log_info "Installiere Anwendung nach /opt..."
    
    # Zielverzeichnis definieren
    TARGET_DIR="/opt/SafetyPermitManager-3"
    CURRENT_DIR=$(pwd)
    
    # Prüfe ob wir bereits in /opt sind
    if [[ "$CURRENT_DIR" == "$TARGET_DIR" ]]; then
        log_success "Anwendung bereits in /opt installiert"
        return
    fi
    
    # Erstelle /opt Verzeichnis falls nicht vorhanden
    sudo mkdir -p /opt
    
    # Kopiere Anwendung nach /opt falls nicht bereits dort
    if [[ ! -d "$TARGET_DIR" ]]; then
        log_info "Kopiere Anwendung nach $TARGET_DIR..."
        sudo cp -r "$CURRENT_DIR" "$TARGET_DIR"
    else
        log_info "Aktualisiere Anwendung in $TARGET_DIR..."
        # Kopiere nur die wichtigsten Dateien, aber bewahre .env
        sudo cp -r "$CURRENT_DIR/dist" "$TARGET_DIR/" 2>/dev/null || true
        sudo cp -r "$CURRENT_DIR/client" "$TARGET_DIR/" 2>/dev/null || true
        sudo cp -r "$CURRENT_DIR/server" "$TARGET_DIR/" 2>/dev/null || true
        sudo cp -r "$CURRENT_DIR/shared" "$TARGET_DIR/" 2>/dev/null || true
        sudo cp "$CURRENT_DIR/package.json" "$TARGET_DIR/" 2>/dev/null || true
        sudo cp "$CURRENT_DIR/package-lock.json" "$TARGET_DIR/" 2>/dev/null || true
        sudo cp "$CURRENT_DIR/.env" "$TARGET_DIR/" 2>/dev/null || true
    fi
    
    # Stelle sicher, dass .env existiert
    if [[ ! -f "$TARGET_DIR/.env" ]] && [[ -f "$CURRENT_DIR/.env" ]]; then
        log_info "Kopiere .env Datei nach $TARGET_DIR..."
        sudo cp "$CURRENT_DIR/.env" "$TARGET_DIR/.env"
    fi
    
    # Setze korrekte Berechtigungen
    USER=$(whoami)
    sudo chown -R $USER:$USER "$TARGET_DIR"
    sudo chmod -R 755 "$TARGET_DIR"
    
    # Sichere Berechtigungen für .env
    if [[ -f "$TARGET_DIR/.env" ]]; then
        sudo chmod 600 "$TARGET_DIR/.env"
    fi
    
    # Wechsle in das neue Verzeichnis
    cd "$TARGET_DIR"
    
    # Rebuild nach Konfigurationsänderungen
    log_info "Rebuilding Anwendung nach Konfigurationsänderungen..."
    npm run build
    
    # Erstelle Development-Wrapper Script
    log_info "Erstelle Development-Wrapper Script..."
    cat > dev.sh << 'EOF'
#!/bin/bash
# Development Wrapper Script für SafetyPermitManager-3
# Lädt automatisch .env Datei

# Wechsle ins Installationsverzeichnis
cd /opt/SafetyPermitManager-3

# Lade .env Datei
if [[ -f ".env" ]]; then
    export $(grep -v '^#' .env | xargs)
    echo "✅ .env Datei geladen"
else
    echo "❌ .env Datei nicht gefunden!"
    exit 1
fi

# Starte Development Server
echo "🚀 Starte Development Server..."
NODE_ENV=development npm run dev
EOF
    
    chmod +x dev.sh
    
    log_success "Anwendung nach /opt installiert"
}

# Erstelle systemd Service
create_systemd_service() {
    log_info "Erstelle systemd Service..."
    
    USER=$(whoami)
    WORK_DIR="/opt/SafetyPermitManager-3"
    
    sudo tee /etc/systemd/system/safety-permit-manager.service > /dev/null << EOF
[Unit]
Description=Safety Permit Manager - Digital Permit Management System
After=network.target postgresql.service
Wants=postgresql.service

[Service]
Type=simple
User=$USER
Group=$USER
WorkingDirectory=$WORK_DIR
Environment=NODE_ENV=production
EnvironmentFile=$WORK_DIR/.env
ExecStart=/usr/bin/node dist/index.js
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=safety-permit-manager

# Security settings (less restrictive for /opt)
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=false
ProtectHome=false
ReadWritePaths=$WORK_DIR

[Install]
WantedBy=multi-user.target
EOF
    
    # Service aktivieren
    sudo systemctl daemon-reload
    sudo systemctl enable safety-permit-manager
    
    log_success "systemd Service erstellt und aktiviert"
}

# Erstelle Backup Script
create_backup_script() {
    log_info "Erstelle Backup Script..."
    
    # Erstelle Backup Script im /opt Verzeichnis
    cat > /opt/SafetyPermitManager-3/backup.sh << 'EOF'
#!/bin/bash

# SafetyPermitManager-3 Backup Script

# Wechsle ins Installationsverzeichnis
cd /opt/SafetyPermitManager-3

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="biggs_permits"
DB_USER="biggs_user"

# Erstelle Backup-Verzeichnis falls nicht vorhanden
mkdir -p "$BACKUP_DIR"

# Datenbank Backup
echo "Erstelle Datenbank Backup..."
pg_dump -h localhost -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_DIR/db_backup_$DATE.sql"

# Uploads Backup
echo "Erstelle Uploads Backup..."
tar -czf "$BACKUP_DIR/uploads_backup_$DATE.tar.gz" uploads/

# Konfiguration Backup
echo "Erstelle Konfiguration Backup..."
cp .env "$BACKUP_DIR/env_backup_$DATE"

# Alte Backups löschen (älter als 30 Tage)
find "$BACKUP_DIR" -name "*backup*" -mtime +30 -delete

echo "Backup abgeschlossen: $DATE"
EOF
    
    chmod +x /opt/SafetyPermitManager-3/backup.sh
    
    log_success "Backup Script erstellt"
}

# Teste die Installation
test_installation() {
    log_info "Teste die Installation..."
    
    # Wechsle ins Installationsverzeichnis
    cd /opt/SafetyPermitManager-3
    
    # Prüfe ob alle Abhängigkeiten verfügbar sind
    if ! command -v node &> /dev/null; then
        log_error "Node.js nicht gefunden!"
        return 1
    fi
    
    if ! command -v npm &> /dev/null; then
        log_error "npm nicht gefunden!"
        return 1
    fi
    
    if ! command -v psql &> /dev/null; then
        log_error "PostgreSQL nicht gefunden!"
        return 1
    fi
    
    # Prüfe Datenbankverbindung
    if ! PGPASSWORD=$DB_PASSWORD psql -h localhost -U biggs_user -d biggs_permits -c "SELECT 1;" &> /dev/null; then
        log_error "Datenbankverbindung fehlgeschlagen!"
        return 1
    fi
    
    # Prüfe ob Build-Dateien existieren
    if [[ ! -f "dist/index.js" ]]; then
        log_error "Build-Dateien nicht gefunden!"
        return 1
    fi
    
    # Prüfe ob .env Datei existiert und DATABASE_URL enthält
    if [[ ! -f ".env" ]]; then
        log_error ".env Datei nicht gefunden!"
        return 1
    fi
    
    if ! grep -q "DATABASE_URL=" .env; then
        log_error "DATABASE_URL nicht in .env Datei gefunden!"
        return 1
    fi
    
    # Prüfe systemd Service-Datei
    if [[ ! -f "/etc/systemd/system/safety-permit-manager.service" ]]; then
        log_error "systemd Service-Datei nicht gefunden!"
        return 1
    fi
    
    # Prüfe ob EnvironmentFile in Service-Datei vorhanden ist
    if ! grep -q "EnvironmentFile=/opt/SafetyPermitManager-3/.env" /etc/systemd/system/safety-permit-manager.service; then
        log_error "EnvironmentFile nicht in systemd Service konfiguriert!"
        return 1
    fi
    
    # Teste Service-Start (kurz)
    log_info "Teste systemd Service..."
    sudo systemctl start safety-permit-manager
    sleep 3
    
    if sudo systemctl is-active --quiet safety-permit-manager; then
        log_success "Service läuft erfolgreich"
        sudo systemctl stop safety-permit-manager
    else
        log_warning "Service-Test fehlgeschlagen - prüfen Sie die Logs mit: sudo journalctl -u safety-permit-manager -f"
        sudo systemctl stop safety-permit-manager 2>/dev/null || true
    fi
    
    log_success "Installation erfolgreich getestet"
}

# Zeige Zusammenfassung
show_summary() {
    echo
    echo "=============================================="
    echo "  SafetyPermitManager-3 Installation Complete"
    echo "=============================================="
    echo
    log_success "Installation erfolgreich abgeschlossen!"
    echo
    echo "Konfiguration:"
    echo "  • Installationsverzeichnis: /opt/SafetyPermitManager-3"
    echo "  • Datenbank: biggs_permits"
    echo "  • Benutzer: biggs_user"
    echo "  • Port: 5000"
    echo "  • Upload-Verzeichnis: /opt/SafetyPermitManager-3/uploads"
    echo
    echo "Standard-Anmeldedaten:"
    echo "  • Admin: admin / password123"
    echo "  • Supervisor: hans.mueller / password123"
    echo "  • Safety Officer: safety.officer / password123"
    echo "  • Operations Manager: ops.manager / password123"
    echo "  • Employee: employee / password123"
    echo
    echo "Wichtige Dateien:"
    echo "  • Konfiguration: /opt/SafetyPermitManager-3/.env"
    echo "  • Development Script: /opt/SafetyPermitManager-3/dev.sh"
    echo "  • Backup Script: /opt/SafetyPermitManager-3/backup.sh"
    echo "  • Service: /etc/systemd/system/safety-permit-manager.service"
    echo
    echo "Nächste Schritte:"
    echo "  1. Starten Sie die Anwendung:"
    echo "     /opt/SafetyPermitManager-3/dev.sh              # Development (empfohlen)"
    echo "     sudo systemctl start safety-permit-manager    # Production"
    echo
    echo "  2. Öffnen Sie http://localhost:5000 im Browser"
    echo
    echo "  3. Melden Sie sich mit dem Admin-Benutzer an:"
    echo "     Username: admin"
    echo "     Passwort: password123"
    echo
    echo "  4. Für Production-Deployment:"
    echo "     • Ändern Sie NODE_ENV=production in .env"
    echo "     • Konfigurieren Sie HTTPS/SSL"
    echo "     • Richten Sie einen Reverse Proxy ein (nginx)"
    echo
    echo "Nützliche Befehle:"
    echo "  • Service Status: sudo systemctl status safety-permit-manager"
    echo "  • Service starten: sudo systemctl start safety-permit-manager"
    echo "  • Service stoppen: sudo systemctl stop safety-permit-manager"
    echo "  • Service neustarten: sudo systemctl restart safety-permit-manager"
    echo "  • Logs anzeigen: sudo journalctl -u safety-permit-manager -f"
    echo "  • Backup erstellen: cd /opt/SafetyPermitManager-3 && ./backup.sh"
    echo "  • Datenbank-Shell: PGPASSWORD='$DB_PASSWORD' psql -h localhost -U biggs_user -d biggs_permits"
    echo "  • Datenbank neu seeden: cd /opt/SafetyPermitManager-3 && npx tsx server/seed.ts"
    echo
    echo "Fehlerbehebung:"
    echo "  • Bei DATABASE_URL Fehlern: Prüfen Sie die .env Datei"
    echo "  • Service lädt .env automatisch: EnvironmentFile ist konfiguriert"
    echo "  • .env Berechtigungen: 600 (nur Besitzer kann lesen/schreiben)"
    echo "  • .env Datei prüfen: cat /opt/SafetyPermitManager-3/.env | grep DATABASE_URL"
    echo "  • Development mit .env: /opt/SafetyPermitManager-3/dev.sh"
    echo
    log_warning "WICHTIG: Notieren Sie sich das Datenbank-Passwort: $DB_PASSWORD"
    echo
}

# Hauptfunktion
main() {
    echo "=============================================="
    echo "  SafetyPermitManager-3 Installation Script"
    echo "  für Debian 12"
    echo "=============================================="
    echo
    
    check_root
    check_debian_version
    
    log_info "Starte Installation..."
    
    update_system
    install_system_dependencies
    install_nodejs
    install_postgresql
    generate_passwords
    setup_database
    install_npm_dependencies
    create_env_file
    create_directories
    initialize_database
    build_application
    install_to_opt
    create_systemd_service
    create_backup_script
    test_installation
    
    show_summary
}

# Script ausführen
main "$@"