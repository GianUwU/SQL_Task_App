-- Beispiele für Stored Procedures und Functions


-- Test 1: Normale Aufgabe mit allen Daten erstellen
CALL CreateTask(
    1,                                  -- p_benutzer_id
    'Projekt Dokumentation',            -- p_titel
    'Umfassende Dokumentation schreiben', -- p_beschreibung
    '2026-02-15 17:00:00',             -- p_deadline
    8.0,                                -- p_geschaetzte_stunden
    0,                                  -- p_status
    '1,2',                              -- p_kategorie_ids
    NULL                                -- p_parent_task_id
);

-- Test 2: Minimale Aufgabe ohne optionale Felder
CALL CreateTask(
    1,                                  -- p_benutzer_id
    'Einfache Aufgabe',                 -- p_titel
    NULL,                               -- p_beschreibung
    NULL,                               -- p_deadline
    NULL,                               -- p_geschaetzte_stunden
    0,                                  -- p_status
    '',                                 -- p_kategorie_ids (leer)
    NULL                                -- p_parent_task_id
);

-- Test 3: Unteraufgabe mit Elternaufgabe erstellen
CALL CreateTask(
    1,                                  -- p_benutzer_id
    'Unteraufgabe testen',              -- p_titel
    'Eine Unteraufgabe',                -- p_beschreibung
    '2026-02-10 12:00:00',             -- p_deadline
    2.5,                                -- p_geschaetzte_stunden
    0,                                  -- p_status
    '1',                                -- p_kategorie_ids
    1                                   -- p_parent_task_id
);

-- SendDueReminders Procedure Tests

-- Test 4: Alle fälligen Erinnerungen versenden
CALL SendDueReminders();

-- Test 5: Erinnerungen nach erneutem Aufruf prüfen
CALL SendDueReminders();

-- Test 6: Gesendete Erinnerungen zählen
SELECT COUNT(*) AS gesendete_erinnerungen
FROM erinnerungen
WHERE gesendet = 1;

-- GetTaskProgress Function Tests

-- Test 7: Fortschritt einer Aufgabe mit Unteraufgaben
SELECT 
    a.aufgabe_id,
    a.titel,
    GetTaskProgress(a.aufgabe_id) AS fortschritt,
    CONCAT(ROUND(GetTaskProgress(a.aufgabe_id) * 100, 0), '%') AS prozent
FROM aufgaben a
WHERE a.aufgabe_id = 1;

-- Test 8: Fortschritt einer Aufgabe ohne Unteraufgaben
SELECT 
    a.aufgabe_id,
    a.titel,
    GetTaskProgress(a.aufgabe_id) AS fortschritt
FROM aufgaben a
WHERE NOT EXISTS (SELECT 1 FROM aufgaben WHERE parent_task_id = a.aufgabe_id)
LIMIT 1;

-- Test 9: Alle Elternaufgaben mit ihrem Fortschritt
SELECT 
    a.aufgabe_id,
    a.titel,
    GetTaskProgress(a.aufgabe_id) AS fortschritt,
    (SELECT COUNT(*) FROM aufgaben WHERE parent_task_id = a.aufgabe_id) AS anzahl_unteraufgaben
FROM aufgaben a
WHERE EXISTS (SELECT 1 FROM aufgaben WHERE parent_task_id = a.aufgabe_id);

-- HasUpcomingReminder Function Tests

-- Test 10: Aufgaben mit kommenden Erinnerungen finden
SELECT 
    a.aufgabe_id,
    a.titel,
    HasUpcomingReminder(a.aufgabe_id) AS hat_erinnerung
FROM aufgaben a
WHERE HasUpcomingReminder(a.aufgabe_id) = 1;

-- Test 11: Alle Aufgaben und ihre Erinnerungen prüfen
SELECT 
    a.aufgabe_id,
    a.titel,
    HasUpcomingReminder(a.aufgabe_id) AS hat_erinnerung,
    CASE 
        WHEN HasUpcomingReminder(a.aufgabe_id) = 1 THEN 'Ja'
        ELSE 'Nein'
    END AS erinnerung_status
FROM aufgaben a
WHERE a.benutzer_id = 1;

-- Test 12: Aufgaben ohne Erinnerungen auflisten
SELECT 
    a.aufgabe_id,
    a.titel
FROM aufgaben a
WHERE HasUpcomingReminder(a.aufgabe_id) = 0
  AND a.status = 0;

-- GetDaysLeft Function Tests

-- Test 13: Verbleibende Tage für alle Aufgaben
SELECT 
    a.aufgabe_id,
    a.titel,
    a.deadline,
    GetDaysLeft(a.aufgabe_id) AS tage_verbleibend,
    CASE 
        WHEN GetDaysLeft(a.aufgabe_id) IS NULL THEN 'Keine Deadline'
        WHEN GetDaysLeft(a.aufgabe_id) < 0 THEN 'Überzogen'
        WHEN GetDaysLeft(a.aufgabe_id) = 0 THEN 'Heute fällig'
        WHEN GetDaysLeft(a.aufgabe_id) <= 3 THEN 'Dringend'
        ELSE 'Normal'
    END AS dringlichkeit
FROM aufgaben a
WHERE a.benutzer_id = 1
ORDER BY GetDaysLeft(a.aufgabe_id);

-- Test 14: Nur überzogene Aufgaben anzeigen
SELECT 
    a.aufgabe_id,
    a.titel,
    GetDaysLeft(a.aufgabe_id) AS tage_überzogen
FROM aufgaben a
WHERE GetDaysLeft(a.aufgabe_id) < 0
  AND a.status = 0;

-- Test 15: Aufgaben ohne Deadline
SELECT 
    a.aufgabe_id,
    a.titel,
    GetDaysLeft(a.aufgabe_id) AS tage_verbleibend
FROM aufgaben a
WHERE GetDaysLeft(a.aufgabe_id) IS NULL;
