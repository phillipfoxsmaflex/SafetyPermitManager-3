# Admin-Benutzer Konfiguration

## 🔐 Automatisch erstellter Admin-Benutzer

Das Installationsskript erstellt automatisch einen Admin-Benutzer mit folgenden Anmeldedaten:

- **Username:** `admin`
- **Passwort:** `password123`
- **Vollständiger Name:** System Administrator
- **Abteilung:** IT
- **Rolle:** admin

## 🚀 Erste Anmeldung

1. Öffnen Sie http://localhost:5000 im Browser
2. Melden Sie sich mit den obigen Anmeldedaten an
3. **WICHTIG:** Ändern Sie das Passwort sofort nach der ersten Anmeldung!

## 🔧 Zusätzlich erstellte Daten

Das Installationsskript erstellt auch:

### Standard-Arbeitsplätze
- Produktionshalle A (Gebäude A, Produktion)
- Produktionshalle B (Gebäude B, Produktion)
- Lagerhalle C (Gebäude C, Lager)
- Wartungsbereich (Gebäude D, Wartung)
- Außenbereich Nord (Außenbereich, Tanks)
- Labor (Gebäude E, Labor)

### System-Einstellungen
- Anwendungstitel: "SafetyPermitManager-3"

## 🔒 Sicherheitshinweise

### Für Development-Umgebung
- Die Standard-Anmeldedaten sind für Testzwecke geeignet
- Ändern Sie das Passwort nach der ersten Anmeldung

### Für Production-Umgebung
**KRITISCH:** Ändern Sie die Anmeldedaten vor dem Produktionseinsatz:

1. **Passwort ändern:**
   - Melden Sie sich als Admin an
   - Gehen Sie zu den Benutzereinstellungen
   - Ändern Sie das Passwort zu einem starken Passwort

2. **Zusätzliche Sicherheitsmaßnahmen:**
   - Erstellen Sie weitere Admin-Benutzer
   - Deaktivieren Sie den Standard-Admin falls gewünscht
   - Implementieren Sie Passwort-Richtlinien
   - Aktivieren Sie Audit-Logging

## 🛠 Admin-Benutzer manuell erstellen

Falls Sie den Admin-Benutzer manuell erstellen möchten:

```sql
-- Verbindung zur Datenbank
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits

-- Admin-Benutzer erstellen
INSERT INTO users (username, password, full_name, department, role)
VALUES ('admin', 'IhrSicheresPasswort', 'System Administrator', 'IT', 'admin');
```

## 🔍 Admin-Benutzer prüfen

```bash
# Mit Health-Check-Script
./health-check.sh

# Manuell in der Datenbank
PGPASSWORD='IhrPasswort' psql -h localhost -U biggs_user -d biggs_permits -c "SELECT username, full_name, role FROM users WHERE role='admin';"
```

## 📋 Admin-Funktionen

Als Admin-Benutzer haben Sie Zugriff auf:

- ✅ Alle Permits anzeigen und bearbeiten
- ✅ Benutzer verwalten
- ✅ System-Einstellungen konfigurieren
- ✅ Arbeitsplätze verwalten
- ✅ Webhook-Konfiguration
- ✅ Backup und Wartung
- ✅ Audit-Logs einsehen

## 🆘 Probleme mit Admin-Benutzer

### Admin-Benutzer existiert nicht
```bash
# Installationsskript erneut ausführen
./install-debian12.sh

# Oder manuell erstellen (siehe oben)
```

### Passwort vergessen
```sql
-- Passwort zurücksetzen
UPDATE users SET password = 'neuesPasswort123' WHERE username = 'admin';
```

### Admin-Rechte prüfen
```sql
-- Admin-Benutzer anzeigen
SELECT * FROM users WHERE role = 'admin';
```

---

**Hinweis:** Für Produktionsumgebungen implementieren Sie zusätzliche Sicherheitsmaßnahmen wie Passwort-Hashing, Multi-Faktor-Authentifizierung und regelmäßige Passwort-Updates.