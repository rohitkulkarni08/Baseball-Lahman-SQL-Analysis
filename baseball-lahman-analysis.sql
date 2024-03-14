-- a. Teams with most number of wins between 1980 and 2022

SELECT
    t.yearID,
    t.teamID,
	t.name AS TeamName,
    t.W AS Wins
FROM
    Teams t
WHERE
    t.yearID BETWEEN 1980 AND 2022
ORDER BY
    Wins DESC
LIMIT 10;

-- b. Teams with the most number of Hall of Fame inductees

SELECT
    t.teamID,
	t.name AS TeamName,
    COUNT(DISTINCT h.playerID) AS HallOfFamePlayers
FROM
    HallOfFame h
JOIN
    Appearances a ON h.playerID = a.playerID
JOIN
    Teams t ON a.teamID = t.teamID AND a.yearID = t.yearID
WHERE
    h.inducted = 'Y'
GROUP BY
    t.teamID
ORDER BY
    HallOfFamePlayers DESC
LIMIT 10;

-- c. Players with most MVP Awards

SELECT 
    AP.playerID,
    People.nameFirst AS FirstName,
    People.nameLast AS LastName,
    COUNT(*) AS MVPAwards
FROM AwardsPlayers AP
JOIN People ON AP.playerID = People.playerID
WHERE AP.awardID = 'Most Valuable Player'
GROUP BY AP.playerID, People.nameFirst, People.nameLast
HAVING MVPAwards > 1
ORDER BY MVPAwards DESC;

-- d. Teams stats over  the years from 1980 to 2022

SELECT
    (FLOOR(yearID / 10) * 10) AS Decade,
    teamID,
    SUM(W) AS TotalWins,
    SUM(L) AS TotalLosses,
    SUM(W) * 1.0 / SUM(W + L) AS WinPercentage,
    SUM(R) AS TotalRuns,
    SUM(SO) AS TotalStrikeouts,
    SUM(SB) AS TotalStolenBases,
    SUM(H + BB + HBP) * 1.0 / SUM(AB + BB + HBP + SF) AS OBP
FROM
    Teams
WHERE
    yearID >= 1980
GROUP BY
    Decade,
    teamID
ORDER BY
    Decade,
    teamID;
	
-- e. Observing a player (Alex Rodriguez) career over the years

SELECT
    b.yearID as Year,
    p.nameFirst AS FirstName,
    p.nameLast AS LastName,
    b.teamID AS Team,
	SUM(b.G) AS Games,
    AVG(b.H * 1.0 / b.AB) AS BattingAverage,
    SUM(b.H) AS Hits,
    SUM(b.HR) AS HomeRuns,
    SUM(b.RBI) AS RBIs,
    SUM(b.SB) AS StolenBases,
    SUM(b.R) AS Runs,
    SUM(b.BB) AS Walks,
	SUM(b.SO) AS Strikeouts
FROM
    Batting b
JOIN
    People p ON b.playerID = p.playerID
WHERE
    b.playerID = 'rodrial01' AND b.AB > 0
GROUP BY
    b.yearID, b.teamID, p.nameFirst, p.nameLast
ORDER BY
    b.yearID;

-- f. Home Run leaders by Decade

WITH DecadeHomeRuns AS (
    SELECT 
        (yearID / 10) * 10 AS Decade,
        playerID,
        SUM(HR) AS TotalHomeRuns,
        RANK() OVER (PARTITION BY (yearID / 10) * 10 ORDER BY SUM(HR) DESC) AS Rank
    FROM Batting
    GROUP BY Decade, playerID
),
RankedPlayers AS (
    SELECT 
        Decade,
        playerID,
        TotalHomeRuns,
        Rank
    FROM DecadeHomeRuns
    WHERE Rank = 1
)
SELECT 
    R.Decade,
    R.playerID,
    R.TotalHomeRuns,
    R.Rank,
    P.nameFirst AS FirstName,
    P.nameLast AS LastName
FROM RankedPlayers R
JOIN People P ON R.playerID = P.playerID
ORDER BY R.Decade, R.Rank;

-- g. Top 10 Batting Averages from 1980 to 2022
WITH Top10BattingAverages AS (
    SELECT 
        yearID,
        playerID,
        RANK() OVER (PARTITION BY yearID ORDER BY AVG(H/AB) DESC) AS Rank
    FROM Batting
    WHERE AB > 0 AND yearID BETWEEN 1980 AND 2022
    GROUP BY yearID, playerID
)
SELECT 
    p.playerID,
    p.nameFirst AS FirstName,
    p.nameLast AS LastName,
    COUNT(*) AS TimesInTop10
FROM Top10BattingAverages t
JOIN People p ON t.playerID = p.playerID
WHERE t.Rank <= 10
GROUP BY p.playerID, p.nameFirst, p.nameLast
ORDER BY TimesInTop10 DESC
LIMIT 10;

-- h. Players with the most stolen bases from 1980 and 2022

WITH YearlyStolenBases AS (
    SELECT 
        yearID,
        playerID,
        SB AS StolenBases,
        RANK() OVER (PARTITION BY yearID ORDER BY SB DESC) AS Rank
    FROM Batting
    WHERE yearID BETWEEN 1980 AND 2022 AND SB IS NOT NULL
)
SELECT 
    YSB.yearID,
    YSB.playerID,
    People.nameFirst AS FirstName,
    People.nameLast AS LastName,
    YSB.StolenBases
FROM YearlyStolenBases YSB
JOIN People ON YSB.playerID = People.playerID
WHERE YSB.Rank = 1
ORDER BY YSB.yearID;

-- i. Players with the 10 best annual Slugging Percentage recorded between 1980 and 2022

SELECT
    p.nameFirst,
    p.nameLast,
    b.playerID,
    b.yearID,
    (CAST(b.H AS FLOAT) - b."2B" - b."3B" - b.HR + (2 * b."2B") + (3 * b."3B") + (4 * b.HR)) / b.AB AS slg
FROM
    Batting b
JOIN
    people p ON b.playerID = p.playerID
WHERE
    b.yearID BETWEEN 1980 AND 2022
    AND b.AB > 50
ORDER BY
    slg DESC
LIMIT 10;

-- j. Pitchers with the most number of strikeouts per year between 1980 and 2022

WITH RankedPitchers AS (
    SELECT 
        yearID,
        playerID,
        SO AS Strikeouts,
        RANK() OVER (PARTITION BY yearID ORDER BY SO DESC) AS Rank
    FROM Pitching
    WHERE yearID BETWEEN 1980 AND 2022
)
SELECT 
    rp.yearID,
    rp.playerID,
    p.nameFirst AS FirstName,
    p.nameLast AS LastName,
    rp.Strikeouts
FROM RankedPitchers rp
JOIN people p ON rp.playerID = p.playerID
WHERE rp.Rank = 1
ORDER BY rp.yearID;

-- k. Most number of Strikeouts every 9 innings between 1980 and 2022

SELECT 
    P.yearID,
    P.playerID,
    People.nameFirst AS FirstName,
    People.nameLast AS LastName,
    (P.SO * 9.0) / (P.IPouts / 3.0) AS StrikeoutsPer9Innings
FROM Pitching P
JOIN People ON P.playerID = People.playerID
WHERE P.IPouts > 0 AND P.yearID BETWEEN 1980 AND 2022
ORDER BY StrikeoutsPer9Innings DESC
LIMIT 5;

-- l. Most Complete Games as a pitcher between 1980 and 2022

WITH DecadeStats AS (
    SELECT 
        (yearID / 10) * 10 AS Decade,
        playerID,
        SUM(CG) AS CompleteGames
    FROM Pitching
    GROUP BY Decade, playerID
)
SELECT 
    DS.Decade,
    DS.playerID,
    People.nameFirst AS FirstName,
    People.nameLast AS LastName,
    DS.CompleteGames
FROM DecadeStats DS
JOIN People ON DS.playerID = People.playerID
WHERE DS.CompleteGames = (
    SELECT MAX(CompleteGames) FROM DecadeStats DS2 WHERE DS2.Decade = DS.Decade
)
ORDER BY DS.Decade, DS.CompleteGames DESC;

-- m. Top 5 pitchers with the lowest ERA for each decade between 1980 and 2022, min 1000 innings pitched

WITH DecadeERA AS (
    SELECT 
        (yearID / 10) * 10 AS Decade,
        playerID,
        SUM(ER) AS EarnedRuns,
        SUM(IPouts) / 3.0 AS InningsPitched
    FROM Pitching
    WHERE yearID BETWEEN 1980 AND 2022
    GROUP BY Decade, playerID
    HAVING InningsPitched >= 1000
),
RankedDecadeERA AS (
    SELECT 
        Decade,
        playerID,
        EarnedRuns / InningsPitched AS ERA,
        RANK() OVER (PARTITION BY Decade ORDER BY EarnedRuns / InningsPitched) AS Rank
    FROM DecadeERA
)
SELECT 
    RDE.Decade,
    RDE.playerID,
    People.nameFirst AS FirstName,
    People.nameLast AS LastName,
    RDE.ERA
FROM RankedDecadeERA RDE
JOIN People ON RDE.playerID = People.playerID
WHERE RDE.Rank <= 5
ORDER BY RDE.Decade, RDE.Rank;