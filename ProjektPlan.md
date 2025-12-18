# Task App – Projektübersicht

## Projektidee
Die Task App hilft Benutzer, ihre Aufgaben effizient zu organisieren und zu verwalten.
Benutzer können Aufgaben erstellen, Fristen setzen, Aufgaben kategorisieren und Erinnerungen erhalten.
Subtasks werden ebenfalls unterstützt, indem eine Aufgabe mit einer übergeordneten Aufgabe verknüpft wird, wodurch eine hierarchische Struktur entsteht.

## Kernfunktionen

### 1. Benutzerverwaltung
- Benutzer können sich mit einem Benutzernamen
- Benutzer können nur ihre eigenen Aufgaben sehen und verwalten.

### 2. Aufgabenverwaltung
- Aufgaben haben:
  - Titel
  - Beschreibung
  - Erstellungsdatum
  - Deadline
  - Geschätzte Bearbeitungszeit
  - Status (erledigt/nicht erledigt)
- Subtasks werden als Aufgaben mit Verweis auf eine übergeordnete Aufgabe dargestellt.
- Benutzer können Aufgaben und Subtasks als erledigt markieren.

### 3. Kategorien
- Aufgaben können einer oder mehreren Kategorien zugeordnet werden (z. B. Arbeit, Schule, Privat).
- Kategorien helfen, Aufgaben nach Art oder Priorität zu organisieren.
- Ein Task kann mehreren Kategorien zugeordnet sein.

### 4. Erinnerungen
- Benutzer können Erinnerungen für Aufgaben erstellen.
- Jede Aufgabe kann mehrere Erinnerungen zu unterschiedlichen Zeiten haben.
- Erinnerungen haben Wichtigkeits-Stufen.
- Erinnerungen haben einen status ob sie schon gesendet wurden.
- Erinnerungen helfen den Benutzer, Fristen einzuhalten.

## Infos zur Datenbankstruktur
- Die Datenbank speichert Informationen zu Benutzer, Aufgaben, Kategorien und Erinnerungen.
- Subtasks werden als Aufgaben mit Verweis auf eine ParentTaskID implementiert.
- Aufgaben können mehreren Kategorien angehören, daher wird eine zusätzliche Tabelle zur Darstellung der n-m-Beziehung benötigt.
- Erinnerungen werden als eigene Entitäten gespeichert, damit mehrere Benachrichtigungen pro Aufgabe möglich sind.
- Unterschiedliche Datentypen werden verwendet, um die Anforderungen zu erfüllen:
  - String (Benutzernamen, Aufgabentitel, Kategorienamen)
  - Integer (IDs)
  - Numeric/Float (geschätzte Stunden)
  - Boolean (erledigt/aktiv)
  - Datum/Zeit (Erstellungsdatum, Deadline, Erinnerungszeit)

## Stored Procedures und Funktionen
Die App wird enthalten:

1. **Stored Procedures** für das Erstellen und Verwalten von Aufgaben:
   - `CreateTask` fügt eine neue Aufgabe ein, ordnet Kategorien zu und erstellt optional Standard-Subtasks.
   - `SendDueReminders` prüft fällige Erinnerungen und markiert sie als gesendet.

2. **Funktionen** zur Berechnung oder Prüfung von Aufgaben:
   - `GetTaskProgress(TaskID)` berechnet den Prozentsatz der erledigten Subtasks.
   - `HasUpcomingReminder(TaskID)` prüft, ob eine Aufgabe zukünftige Erinnerungen hat.
   - `GetDaysLeft(TaskID)` berechnet die anzahl Tage übrig bis zur Deadline der Aufgabe.

Jede Procedure und Funktion muss mindestens drei Operationen durchführen, um die Anforderungen der Aufgabenstellung zu erfüllen.

## Testdaten
- Jede Tabelle der Datenbank wird mindestens 10 Testeinträge enthalten.
- Dies stellt sicher, dass die Funktionen getestet und demonstriert werden können:
  - Mehrere Benutzer
  - Aufgaben und Subtasks
  - Mehrere Kategorien pro Aufgabe
  - Mehrere Erinnerungen pro Aufgabe

---

## Zusammenfassung
Die Datenbank der Task App ist so konzipiert, dass sie:

- Mehrere Benutzer und Aufgaben unterstützt
- Aufgaben hierarchisch mit Subtasks organisiert
- Aufgaben mehreren Kategorien zuordnet
- Erinnerungen für Aufgaben bereitstellt
- Verschiedene Datentypen, Fremdschlüsselbeziehungen und automatisch hochzählende IDs verwendet
- Stored Procedures und Funktionen für Automatisierungen und Berechnungen nutzt