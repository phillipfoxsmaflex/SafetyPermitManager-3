#!/bin/bash

# SafetyPermitManager-3 Health Check Script
# Überprüft den Status aller wichtigen Komponenten

set -e

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
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Lade .env Datei falls vorhanden
if [[ -f ".env" ]]; then
    source .env
fi

echo "=============================================="
echo "  SafetyPermitManager-3 Health Check"
echo "  $(date)"
echo "=============================================="
echo

# 1. System-Informationen
log_info "System-Informationen"
echo "  OS: $(cat /etc/debian_version 2>/dev/null || echo 'Unbekannt')"
echo "  Kernel: $(uname -r)"
echo "  Uptime: $(uptime -p 2>/dev/null || uptime)"
echo

# 2. Node.js und npm prüfen
log_info "Node.js und npm"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    log_success "Node.js $NODE_VERSION installiert"
else
    log_error "Node.js nicht gefunden!"
    exit 1
fi

if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    log_success "npm $NPM_VERSION installiert"
else
    log_error "npm nicht gefunden!"
    exit 1
fi
echo

# 3. PostgreSQL prüfen
log_info "PostgreSQL Status"
if command -v psql &> /dev/null; then
    if sudo systemctl is-active postgresql &> /dev/null; then
        log_success "PostgreSQL Service läuft"
        
        # Datenbankverbindung testen
        if [[ -n "$PGPASSWORD" && -n "$PGUSER" && -n "$PGDATABASE" ]]; then
            if PGPASSWORD="$PGPASSWORD" psql -h localhost -U "$PGUSER" -d "$PGDATABASE" -c "SELECT 1;" &> /dev/null; then
                log_success "Datenbankverbindung erfolgreich"
                
                # Admin-Benutzer prüfen
                ADMIN_EXISTS=$(PGPASSWORD="$PGPASSWORD" psql -h localhost -U "$PGUSER" -d "$PGDATABASE" -t -c "SELECT COUNT(*) FROM users WHERE username='admin';" 2>/dev/null | tr -d ' ')
                if [[ "$ADMIN_EXISTS" == "1" ]]; then
                    log_success "Admin-Benutzer existiert"
                else
                    log_warning "Admin-Benutzer nicht gefunden"
                fi
            else
                log_error "Datenbankverbindung fehlgeschlagen"
            fi
        else
            log_warning "Datenbank-Credentials nicht in .env gefunden"
        fi
    else
        log_error "PostgreSQL Service läuft nicht"
    fi
else
    log_error "PostgreSQL nicht installiert"
fi
echo

# 4. Anwendungs-Service prüfen
log_info "SafetyPermitManager Service"
if sudo systemctl list-unit-files | grep -q safety-permit-manager; then
    if sudo systemctl is-active safety-permit-manager &> /dev/null; then
        log_success "Service läuft"
    else
        log_warning "Service ist nicht aktiv"
        echo "  Status: $(sudo systemctl is-active safety-permit-manager)"
    fi
    
    if sudo systemctl is-enabled safety-permit-manager &> /dev/null; then
        log_success "Service ist aktiviert (Autostart)"
    else
        log_warning "Service ist nicht für Autostart aktiviert"
    fi
else
    log_warning "systemd Service nicht gefunden"
fi
echo

# 5. Port und Netzwerk prüfen
log_info "Netzwerk und Ports"
PORT=${PORT:-5000}

if sudo netstat -tlnp 2>/dev/null | grep -q ":$PORT "; then
    log_success "Port $PORT ist in Verwendung"
else
    log_warning "Port $PORT ist nicht in Verwendung"
fi

# HTTP-Verbindung testen
if curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT 2>/dev/null | grep -q "200\|302\|404"; then
    log_success "HTTP-Server antwortet auf Port $PORT"
else
    log_warning "HTTP-Server antwortet nicht auf Port $PORT"
fi
echo

# 6. Dateisystem prüfen
log_info "Dateisystem und Verzeichnisse"

# Wichtige Verzeichnisse prüfen
for dir in "uploads" "logs" "backups" "dist" "node_modules"; do
    if [[ -d "$dir" ]]; then
        log_success "Verzeichnis '$dir' existiert"
    else
        log_warning "Verzeichnis '$dir' fehlt"
    fi
done

# .env Datei prüfen
if [[ -f ".env" ]]; then
    log_success ".env Datei existiert"
    
    # Wichtige Variablen prüfen
    if grep -q "DATABASE_URL=" .env; then
        log_success "DATABASE_URL konfiguriert"
    else
        log_error "DATABASE_URL fehlt in .env"
    fi
    
    if grep -q "SESSION_SECRET=" .env; then
        SECRET_LENGTH=$(grep "SESSION_SECRET=" .env | cut -d'=' -f2 | wc -c)
        if [[ $SECRET_LENGTH -gt 32 ]]; then
            log_success "SESSION_SECRET konfiguriert (Länge: $SECRET_LENGTH)"
        else
            log_warning "SESSION_SECRET zu kurz (Länge: $SECRET_LENGTH)"
        fi
    else
        log_error "SESSION_SECRET fehlt in .env"
    fi
else
    log_error ".env Datei fehlt"
fi
echo

# 7. Festplattenspeicher prüfen
log_info "Festplattenspeicher"
df -h | grep -E "(Filesystem|/$|/var|/tmp)" | while read line; do
    if echo "$line" | grep -q "Filesystem"; then
        echo "  $line"
    else
        USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
        if [[ $USAGE -gt 90 ]]; then
            log_error "  $line"
        elif [[ $USAGE -gt 80 ]]; then
            log_warning "  $line"
        else
            echo "  $line"
        fi
    fi
done
echo

# 8. Speicher prüfen
log_info "Arbeitsspeicher"
free -h | while read line; do
    echo "  $line"
done
echo

# 9. Prozesse prüfen
log_info "Relevante Prozesse"
ps aux | grep -E "(node|postgres)" | grep -v grep | while read line; do
    echo "  $line"
done
echo

# 10. Letzte Logs prüfen
log_info "Letzte Service-Logs (falls verfügbar)"
if sudo systemctl list-unit-files | grep -q safety-permit-manager; then
    echo "  Letzte 5 Log-Einträge:"
    sudo journalctl -u safety-permit-manager --no-pager -n 5 | tail -n 5 | while read line; do
        echo "    $line"
    done
else
    log_warning "Keine systemd Service-Logs verfügbar"
fi
echo

# 11. Zusammenfassung
echo "=============================================="
echo "  Health Check Zusammenfassung"
echo "=============================================="

# Kritische Komponenten prüfen
CRITICAL_OK=true

if ! command -v node &> /dev/null; then
    log_error "Node.js fehlt"
    CRITICAL_OK=false
fi

if ! command -v psql &> /dev/null; then
    log_error "PostgreSQL fehlt"
    CRITICAL_OK=false
fi

if ! sudo systemctl is-active postgresql &> /dev/null; then
    log_error "PostgreSQL läuft nicht"
    CRITICAL_OK=false
fi

if [[ ! -f ".env" ]]; then
    log_error ".env Datei fehlt"
    CRITICAL_OK=false
fi

if $CRITICAL_OK; then
    log_success "Alle kritischen Komponenten sind verfügbar"
    echo
    echo "Nächste Schritte:"
    echo "  • Anwendung starten: npm run dev"
    echo "  • Service starten: sudo systemctl start safety-permit-manager"
    echo "  • Browser öffnen: http://localhost:$PORT"
    echo "  • Anmelden mit: admin / password123"
    exit 0
else
    log_error "Kritische Probleme gefunden!"
    echo
    echo "Empfohlene Aktionen:"
    echo "  • Installationsskript erneut ausführen: ./install-debian12.sh"
    echo "  • Dokumentation prüfen: README.md"
    echo "  • Support kontaktieren mit dieser Ausgabe"
    exit 1
fi