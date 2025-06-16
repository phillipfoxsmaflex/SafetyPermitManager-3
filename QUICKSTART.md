# SafetyPermitManager-3 - Schnellstart

## ⚡ Installation in 3 Schritten

### 1. Repository klonen
```bash
git clone https://github.com/phillipfoxsmaflex/SafetyPermitManager-3.git
cd SafetyPermitManager-3
```

### 2. Automatische Installation
```bash
chmod +x install-debian12.sh
./install-debian12.sh
```

### 3. Anwendung starten
```bash
npm run dev
```

**Fertig!** Öffnen Sie http://localhost:5000 im Browser.

---

## 🎯 Ein-Befehl-Installation

```bash
curl -fsSL https://raw.githubusercontent.com/phillipfoxsmaflex/SafetyPermitManager-3/main/install-debian12.sh | bash
```

---

## 📋 Was wird installiert?

- ✅ Node.js 18+
- ✅ PostgreSQL Datenbank
- ✅ Alle npm-Abhängigkeiten
- ✅ Datenbank-Schema
- ✅ systemd Service
- ✅ Backup-Script

---

## 🔧 Wichtige Befehle

### Development
```bash
npm run dev          # Development-Server starten
npm run build        # Anwendung bauen
npm run check        # TypeScript prüfen
```

### Production
```bash
sudo systemctl start safety-permit-manager    # Service starten
sudo systemctl status safety-permit-manager   # Status prüfen
sudo systemctl stop safety-permit-manager     # Service stoppen
```

### Wartung
```bash
./backup.sh          # Backup erstellen
./health-check.sh    # System-Check
```

---

## 🌐 Erste Schritte

1. **Browser öffnen:** http://localhost:5000
2. **Mit Admin-Benutzer anmelden:**
   - Username: `admin`
   - Passwort: `password123`
3. **System konfigurieren** und Admin-Passwort ändern
4. **Ersten Permit erstellen**

---

## 🆘 Probleme?

### Schnelle Diagnose
```bash
./health-check.sh    # Vollständiger System-Check
```

### Häufige Lösungen
```bash
# Service neu starten
sudo systemctl restart safety-permit-manager

# Logs anzeigen
sudo journalctl -u safety-permit-manager -f

# Datenbank testen
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "SELECT 1;"
```

---

## 📚 Weitere Dokumentation

- **Vollständige Anleitung:** [README.md](README.md)
- **Detaillierte Installation:** [INSTALLATION.md](INSTALLATION.md)
- **Systemanforderungen:** Debian 12, 2GB RAM, 5GB Festplatte

---

**Hinweis:** Für Produktionsumgebungen siehe [README.md](README.md) für Sicherheits- und Performance-Konfiguration.