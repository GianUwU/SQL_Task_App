-- Stored Procedures for Task App

CREATE PROCEDURE CreateTask
    @BenutzerID INT,
    @Titel VARCHAR(100),
    @Beschreibung NVARCHAR(MAX),
    @Deadline DATETIME = NULL,
    @GeschaetzteStunden FLOAT = NULL,
    @Status BIT = 0,
    @KategorieIDs VARCHAR(100), -- Kommagetrennte Liste von KategorieIDs
    @ParentTaskID INT = NULL
AS
BEGIN
    -- Aufgabe einfügen
    INSERT INTO Aufgaben (BenutzerID, ParentTaskID, Titel, Beschreibung, Deadline, GeschaetzteStunden, Status)
    VALUES (@BenutzerID, @ParentTaskID, @Titel, @Beschreibung, @Deadline, @GeschaetzteStunden, @Status);
    DECLARE @NewTaskID INT = SCOPE_IDENTITY();
    -- Kategorien zuordnen
    DECLARE @xml xml = N'<i>' + REPLACE(@KategorieIDs, ',', '</i><i>') + '</i>';
    INSERT INTO Aufgaben_Kategorien (AufgabeID, KategorieID)
    SELECT @NewTaskID, T.N.value('.', 'INT')
    FROM @xml.nodes('//i') T(N);
END
GO

-- SendDueReminders: Prüft fällige Erinnerungen und markiert sie als gesendet
CREATE PROCEDURE SendDueReminders
AS
BEGIN
    -- Hier könnte Logik zum Versenden von Erinnerungen eingefügt werden
    UPDATE Erinnerungen
    SET Gesendet = 1
    WHERE Gesendet = 0 AND Erinnerungszeit <= GETDATE();
END
GO
