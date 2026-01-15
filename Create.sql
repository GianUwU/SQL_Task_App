-- Datenbankschema für die Task App

-- Benutzer-Tabelle
CREATE TABLE benutzer (
    benutzer_id INT PRIMARY KEY AUTO_INCREMENT,
    benutzername VARCHAR(50) NOT NULL UNIQUE
);

-- Aufgaben-Tabelle
CREATE TABLE aufgaben (
    aufgabe_id INT PRIMARY KEY AUTO_INCREMENT,
    benutzer_id INT NOT NULL,
    parent_task_id INT NULL,
    titel VARCHAR(100) NOT NULL,
    beschreibung TEXT,
    erstellungsdatum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deadline DATETIME,
    geschaetzte_stunden FLOAT,
    status BOOLEAN NOT NULL DEFAULT 0, -- 0 = nicht erledigt, 1 = erledigt
    FOREIGN KEY (benutzer_id) REFERENCES benutzer(benutzer_id),
    FOREIGN KEY (parent_task_id) REFERENCES aufgaben(aufgabe_id)
);

-- Kategorien-Tabelle
CREATE TABLE kategorien (
    kategorie_id INT PRIMARY KEY AUTO_INCREMENT,
    kategoriename VARCHAR(50) NOT NULL UNIQUE
);

-- n:m-Tabelle Aufgaben_Kategorien
CREATE TABLE aufgaben_kategorien (
    aufgabe_id INT NOT NULL,
    kategorie_id INT NOT NULL,
    PRIMARY KEY (aufgabe_id, kategorie_id),
    FOREIGN KEY (aufgabe_id) REFERENCES aufgaben(aufgabe_id) ON DELETE CASCADE,
    FOREIGN KEY (kategorie_id) REFERENCES kategorien(kategorie_id) ON DELETE CASCADE
);

-- Erinnerungen-Tabelle
CREATE TABLE erinnerungen (
    erinnerung_id INT PRIMARY KEY AUTO_INCREMENT,
    aufgabe_id INT NOT NULL,
    erinnerungszeit DATETIME NOT NULL,
    wichtigkeit INT NOT NULL CHECK (wichtigkeit BETWEEN 1 AND 3), -- 1 = niedrig, 2 = mittel, 3 = hoch
    gesendet BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (aufgabe_id) REFERENCES aufgaben(aufgabe_id) ON DELETE CASCADE
);

-- Indexe für schnellere Abfragen
CREATE INDEX ix_aufgaben_benutzer_id ON aufgaben(benutzer_id);
CREATE INDEX ix_erinnerungen_zeit ON erinnerungen(erinnerungszeit);

-- Stored Procedures

DELIMITER //

CREATE PROCEDURE CreateTask(
    IN p_benutzer_id INT,
    IN p_titel VARCHAR(100),
    IN p_beschreibung TEXT,
    IN p_deadline DATETIME,
    IN p_geschaetzte_stunden FLOAT,
    IN p_status BOOLEAN,
    IN p_kategorie_ids VARCHAR(100), -- Kommagetrennte Liste von KategorieIDs
    IN p_parent_task_id INT
)
BEGIN
    DECLARE v_new_task_id INT;
    DECLARE v_kategorie_id INT;
    DECLARE v_pos INT;
    DECLARE v_remaining_ids VARCHAR(100);
    
    -- Aufgabe einfügen
    INSERT INTO aufgaben (benutzer_id, parent_task_id, titel, beschreibung, deadline, geschaetzte_stunden, status)
    VALUES (p_benutzer_id, p_parent_task_id, p_titel, p_beschreibung, p_deadline, p_geschaetzte_stunden, p_status);
    
    SET v_new_task_id = LAST_INSERT_ID();
    
    -- Kategorien zuordnen (kommagetrennte Liste verarbeiten)
    SET v_remaining_ids = CONCAT(p_kategorie_ids, ',');
    
    WHILE LENGTH(v_remaining_ids) > 0 DO
        SET v_pos = LOCATE(',', v_remaining_ids);
        IF v_pos > 1 THEN
            SET v_kategorie_id = CAST(SUBSTRING(v_remaining_ids, 1, v_pos - 1) AS UNSIGNED);
            INSERT INTO aufgaben_kategorien (aufgabe_id, kategorie_id)
            VALUES (v_new_task_id, v_kategorie_id);
        END IF;
        SET v_remaining_ids = SUBSTRING(v_remaining_ids, v_pos + 1);
    END WHILE;
END//

-- SendDueReminders: Prüft fällige Erinnerungen und markiert sie als gesendet
CREATE PROCEDURE SendDueReminders()
BEGIN
    -- Hier könnte Logik zum Versenden von Erinnerungen eingefügt werden
    UPDATE erinnerungen
    SET gesendet = 1
    WHERE gesendet = 0 AND erinnerungszeit <= NOW();
END//

DELIMITER ;

-- Functions

DELIMITER //

-- GetTaskProgress: Berechnet den Prozentsatz der erledigten Subtasks
CREATE FUNCTION GetTaskProgress(task_id INT)
RETURNS FLOAT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total INT;
    DECLARE done INT;
    
    SELECT COUNT(*) INTO total FROM aufgaben WHERE parent_task_id = task_id;
    IF total = 0 THEN
        RETURN 1.0;
    END IF;
    
    SELECT COUNT(*) INTO done FROM aufgaben WHERE parent_task_id = task_id AND status = 1;
    RETURN done / total;
END//

-- HasUpcomingReminder: Prüft, ob eine Aufgabe zukünftige Erinnerungen hat
CREATE FUNCTION HasUpcomingReminder(task_id INT)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    IF EXISTS (SELECT 1 FROM erinnerungen WHERE aufgabe_id = task_id AND erinnerungszeit > NOW() AND gesendet = 0) THEN
        RETURN 1;
    END IF;
    RETURN 0;
END//

-- GetDaysLeft: Berechnet die Anzahl Tage bis zur Deadline
CREATE FUNCTION GetDaysLeft(task_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE deadline_date DATETIME;
    
    SELECT deadline INTO deadline_date FROM aufgaben WHERE aufgabe_id = task_id;
    IF deadline_date IS NULL THEN
        RETURN NULL;
    END IF;
    
    RETURN DATEDIFF(deadline_date, NOW());
END//

DELIMITER ;
