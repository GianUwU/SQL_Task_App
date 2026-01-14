-- Functions for Task App

-- GetTaskProgress: Berechnet den Prozentsatz der erledigten Subtasks
CREATE FUNCTION GetTaskProgress(@TaskID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Total INT, @Done INT;
    SELECT @Total = COUNT(*) FROM Aufgaben WHERE ParentTaskID = @TaskID;
    IF @Total = 0 RETURN 1.0;
    SELECT @Done = COUNT(*) FROM Aufgaben WHERE ParentTaskID = @TaskID AND Status = 1;
    RETURN CAST(@Done AS FLOAT) / @Total;
END
GO

-- HasUpcomingReminder: Prüft, ob eine Aufgabe zukünftige Erinnerungen hat
CREATE FUNCTION HasUpcomingReminder(@TaskID INT)
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Erinnerungen WHERE AufgabeID = @TaskID AND Erinnerungszeit > GETDATE() AND Gesendet = 0)
        RETURN 1;
    RETURN 0;
END
GO

-- GetDaysLeft: Berechnet die Anzahl Tage bis zur Deadline
CREATE FUNCTION GetDaysLeft(@TaskID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Deadline DATETIME;
    SELECT @Deadline = Deadline FROM Aufgaben WHERE AufgabeID = @TaskID;
    IF @Deadline IS NULL RETURN NULL;
    RETURN DATEDIFF(DAY, GETDATE(), @Deadline);
END
GO
