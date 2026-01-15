-- Beispiele für Stored Procedures und Functions

-- Beispiel 1: Neue Aufgabe mit Kategorien erstellen
CALL CreateTask(
    1,                                  -- p_benutzer_id
    'Complete Project Documentation',   -- p_titel
    'Write comprehensive documentation for the task management system', -- p_beschreibung
    '2026-02-15 17:00:00',             -- p_deadline
    8.0,                                -- p_geschaetzte_stunden
    0,                                  -- p_status (nicht erledigt)
    '1,2',                              -- p_kategorie_ids
    NULL                                -- p_parent_task_id (keine Elternaufgabe)
);

-- Beispiel 2: Erinnerungen senden
CALL SendDueReminders();

-- Beispiel 3: Fortschritt einer Aufgabe prüfen
SELECT 
    a.titel,
    GetTaskProgress(a.aufgabe_id) AS progress_percentage,
    CONCAT(ROUND(GetTaskProgress(a.aufgabe_id) * 100, 2), '%') AS progress_display
FROM aufgaben a
WHERE a.aufgabe_id = 1;

-- Beispiel 4: Verbleibende Tage bis zur Deadline
SELECT 
    a.aufgabe_id,
    a.titel,
    a.deadline,
    GetDaysLeft(a.aufgabe_id) AS days_remaining,
    CASE 
        WHEN GetDaysLeft(a.aufgabe_id) IS NULL THEN 'Keine Deadline'
        WHEN GetDaysLeft(a.aufgabe_id) < 0 THEN 'Überzogen'
        WHEN GetDaysLeft(a.aufgabe_id) = 0 THEN 'Heute'
        WHEN GetDaysLeft(a.aufgabe_id) <= 3 THEN 'Bald'
        ELSE 'Noch nicht'
    END AS deadline_status
FROM aufgaben a
WHERE a.benutzer_id = 1
ORDER BY GetDaysLeft(a.aufgabe_id);

-- Beispiel 5: Umfassende Aufgabenübersicht mit mehreren Functions
SELECT 
    a.aufgabe_id,
    a.titel,
    a.status AS is_completed,
    GetTaskProgress(a.aufgabe_id) AS subtask_progress,
    GetDaysLeft(a.aufgabe_id) AS days_left,
    HasUpcomingReminder(a.aufgabe_id) AS has_reminder,
    CASE 
        WHEN GetDaysLeft(a.aufgabe_id) IS NULL THEN 'Keine Deadline'
        WHEN GetDaysLeft(a.aufgabe_id) < 0 THEN 'Überzogen'
        WHEN GetDaysLeft(a.aufgabe_id) = 0 THEN 'Heute'
        WHEN GetDaysLeft(a.aufgabe_id) <= 3 THEN 'Bald'
        ELSE 'Noch nicht'
    END AS task_priority
FROM aufgaben a
WHERE a.benutzer_id = 1;

-- Beispiel 6: Aufgaben die Aufmerksamkeit benötigen
SELECT 
    a.aufgabe_id,
    a.titel,
    GetDaysLeft(a.aufgabe_id) AS days_left,
    HasUpcomingReminder(a.aufgabe_id) AS has_reminder,
    'Benötigt Aufmerksamkeit!' AS alert
FROM aufgaben a
WHERE a.status = 0  -- Nicht erledigt
  AND (
      GetDaysLeft(a.aufgabe_id) < 0  -- Überzogen
      OR (GetDaysLeft(a.aufgabe_id) <= 3 AND HasUpcomingReminder(a.aufgabe_id) = 0)  -- Bald fällig aber ohne Erinnerung
  )
  AND a.benutzer_id = 1;
