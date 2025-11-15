-- ============================================
-- TOKYO OLYMPICS DATA ANALYTICS
-- Azure Synapse SQL Queries
-- ============================================

-- ============================================
-- 1. MEDAL ANALYSIS
-- ============================================

-- Total medals by country (Top 20)
SELECT TOP 20
    TeamCountry,
    Gold,
    Silver,
    Bronze,
    Total,
    Rank_by_Total,
    ROUND(CAST(Gold AS FLOAT) / NULLIF(Total, 0) * 100, 2) AS GoldPercentage
FROM medals
ORDER BY Total DESC, Gold DESC;

-- Countries with most Gold medals
SELECT TOP 10
    TeamCountry,
    Gold,
    Total,
    ROUND(CAST(Gold AS FLOAT) / NULLIF(Total, 0) * 100, 2) AS GoldRate
FROM medals
WHERE Gold > 0
ORDER BY Gold DESC;

-- Medal distribution analysis
SELECT 
    COUNT(DISTINCT TeamCountry) AS TotalCountries,
    SUM(Gold) AS TotalGold,
    SUM(Silver) AS TotalSilver,
    SUM(Bronze) AS TotalBronze,
    SUM(Total) AS TotalMedals,
    ROUND(AVG(CAST(Total AS FLOAT)), 2) AS AvgMedalsPerCountry
FROM medals;

-- Countries above average medal count
WITH AvgMedals AS (
    SELECT AVG(CAST(Total AS FLOAT)) AS AvgTotal
    FROM medals
)
SELECT 
    m.TeamCountry,
    m.Total,
    am.AvgTotal,
    m.Total - am.AvgTotal AS DifferenceFromAvg
FROM medals m
CROSS JOIN AvgMedals am
WHERE m.Total > am.AvgTotal
ORDER BY m.Total DESC;

-- Medal efficiency (medals per athlete)
SELECT 
    m.TeamCountry,
    m.Total AS TotalMedals,
    COUNT(DISTINCT a.PersonName) AS TotalAthletes,
    ROUND(CAST(m.Total AS FLOAT) / NULLIF(COUNT(DISTINCT a.PersonName), 0), 2) AS MedalsPerAthlete
FROM medals m
LEFT JOIN athletes a ON m.TeamCountry = a.Country
GROUP BY m.TeamCountry, m.Total
HAVING COUNT(DISTINCT a.PersonName) > 0
ORDER BY MedalsPerAthlete DESC;

-- ============================================
-- 2. ATHLETE ANALYSIS
-- ============================================

-- Total athletes by country
SELECT 
    Country,
    COUNT(DISTINCT PersonName) AS TotalAthletes,
    COUNT(DISTINCT Discipline) AS DisciplinesParticipated
FROM athletes
GROUP BY Country
ORDER BY TotalAthletes DESC;

-- Athletes per discipline
SELECT 
    Discipline,
    COUNT(DISTINCT PersonName) AS AthleteCount,
    COUNT(DISTINCT Country) AS CountriesParticipating
FROM athletes
GROUP BY Discipline
ORDER BY AthleteCount DESC;

-- Most popular disciplines (by athlete participation)
SELECT TOP 10
    Discipline,
    COUNT(DISTINCT PersonName) AS TotalAthletes,
    COUNT(DISTINCT Country) AS CountriesInvolved
FROM athletes
GROUP BY Discipline
ORDER BY TotalAthletes DESC;

-- Countries with most diverse participation
SELECT TOP 15
    Country,
    COUNT(DISTINCT Discipline) AS DisciplineCount,
    COUNT(DISTINCT PersonName) AS AthleteCount
FROM athletes
GROUP BY Country
ORDER BY DisciplineCount DESC, AthleteCount DESC;

-- Athletes in multiple disciplines (if any)
SELECT 
    PersonName,
    Country,
    COUNT(DISTINCT Discipline) AS DisciplineCount,
    STRING_AGG(Discipline, ', ') AS Disciplines
FROM athletes
GROUP BY PersonName, Country
HAVING COUNT(DISTINCT Discipline) > 1
ORDER BY DisciplineCount DESC;

-- ============================================
-- 3. GENDER ANALYSIS
-- ============================================

-- Overall gender distribution
SELECT 
    SUM(Female) AS TotalFemale,
    SUM(Male) AS TotalMale,
    SUM(Total) AS TotalParticipants,
    ROUND(CAST(SUM(Female) AS FLOAT) / NULLIF(SUM(Total), 0) * 100, 2) AS FemalePercentage,
    ROUND(CAST(SUM(Male) AS FLOAT) / NULLIF(SUM(Total), 0) * 100, 2) AS MalePercentage
FROM entriesgender;

-- Gender balance by discipline
SELECT 
    Discipline,
    Female,
    Male,
    Total,
    ROUND(CAST(Female AS FLOAT) / NULLIF(Total, 0) * 100, 2) AS FemalePercentage,
    ROUND(CAST(Male AS FLOAT) / NULLIF(Total, 0) * 100, 2) AS MalePercentage,
    ABS(Female - Male) AS GenderGap,
    CASE 
        WHEN ABS(Female - Male) <= (Total * 0.1) THEN 'Balanced'
        WHEN Female > Male THEN 'Female Dominant'
        ELSE 'Male Dominant'
    END AS GenderBalance
FROM entriesgender
ORDER BY Total DESC;

-- Most gender-balanced disciplines
SELECT TOP 10
    Discipline,
    Female,
    Male,
    Total,
    ABS(Female - Male) AS GenderGap,
    ROUND(CAST(ABS(Female - Male) AS FLOAT) / NULLIF(Total, 0) * 100, 2) AS GapPercentage
FROM entriesgender
WHERE Total > 0
ORDER BY GapPercentage ASC;

-- Disciplines with significant gender imbalance
SELECT 
    Discipline,
    Female,
    Male,
    Total,
    CASE 
        WHEN Female = 0 THEN 'Male Only'
        WHEN Male = 0 THEN 'Female Only'
        WHEN CAST(Female AS FLOAT) / Male > 2 THEN 'Female Dominated'
        WHEN CAST(Male AS FLOAT) / Female > 2 THEN 'Male Dominated'
        ELSE 'Balanced'
    END AS DominanceType
FROM entriesgender
WHERE (Female = 0 OR Male = 0 OR 
       CAST(Female AS FLOAT) / NULLIF(Male, 0) > 2 OR 
       CAST(Male AS FLOAT) / NULLIF(Female, 0) > 2)
ORDER BY Total DESC;

-- ============================================
-- 4. COACH ANALYSIS
-- ============================================

-- Coaches by country
SELECT 
    Country,
    COUNT(DISTINCT Name) AS TotalCoaches,
    COUNT(DISTINCT Discipline) AS DisciplinesCovered,
    COUNT(DISTINCT Event) AS EventsCovered
FROM coaches
GROUP BY Country
ORDER BY TotalCoaches DESC;

-- Coaches per discipline
SELECT 
    Discipline,
    COUNT(DISTINCT Name) AS CoachCount,
    COUNT(DISTINCT Country) AS CountriesInvolved,
    COUNT(DISTINCT Event) AS EventCount
FROM coaches
GROUP BY Discipline
ORDER BY CoachCount DESC;

-- Coach to athlete ratio by country
SELECT 
    c.Country,
    COUNT(DISTINCT c.Name) AS TotalCoaches,
    COUNT(DISTINCT a.PersonName) AS TotalAthletes,
    ROUND(CAST(COUNT(DISTINCT a.PersonName) AS FLOAT) / NULLIF(COUNT(DISTINCT c.Name), 0), 2) AS AthletePerCoach
FROM coaches c
LEFT JOIN athletes a ON c.Country = a.Country
GROUP BY c.Country
HAVING COUNT(DISTINCT c.Name) > 0
ORDER BY AthletePerCoach DESC;

-- ============================================
-- 5. TEAM ANALYSIS
-- ============================================

-- Teams by country
SELECT 
    Country,
    COUNT(DISTINCT TeamName) AS TotalTeams,
    COUNT(DISTINCT Discipline) AS DisciplinesInvolved,
    COUNT(DISTINCT Event) AS EventsParticipated
FROM teams
GROUP BY Country
ORDER BY TotalTeams DESC;

-- Teams per discipline
SELECT 
    Discipline,
    COUNT(DISTINCT TeamName) AS TeamCount,
    COUNT(DISTINCT Country) AS CountriesRepresented,
    COUNT(DISTINCT Event) AS EventCount
FROM teams
GROUP BY Discipline
ORDER BY TeamCount DESC;

-- Most competitive events (most teams)
SELECT TOP 15
    Event,
    Discipline,
    COUNT(DISTINCT TeamName) AS TeamCount,
    COUNT(DISTINCT Country) AS CountriesCompeting
FROM teams
GROUP BY Event, Discipline
ORDER BY TeamCount DESC;

-- ============================================
-- 6. COMPREHENSIVE ANALYTICS
-- ============================================

-- Complete country profile
SELECT 
    a.Country,
    COUNT(DISTINCT a.PersonName) AS Athletes,
    COUNT(DISTINCT a.Discipline) AS AthleteDisciplines,
    COUNT(DISTINCT t.TeamName) AS Teams,
    COUNT(DISTINCT c.Name) AS Coaches,
    m.Gold,
    m.Silver,
    m.Bronze,
    m.Total AS TotalMedals,
    m.Rank_by_Total
FROM athletes a
LEFT JOIN teams t ON a.Country = t.Country
LEFT JOIN coaches c ON a.Country = c.Country
LEFT JOIN medals m ON a.Country = m.TeamCountry
GROUP BY 
    a.Country, m.Gold, m.Silver, m.Bronze, m.Total, m.Rank_by_Total
ORDER BY m.Total DESC, Athletes DESC;

-- Discipline performance analysis
SELECT 
    a.Discipline,
    COUNT(DISTINCT a.PersonName) AS TotalAthletes,
    COUNT(DISTINCT a.Country) AS CountriesParticipating,
    eg.Female,
    eg.Male,
    eg.Total AS GenderTotal,
    COUNT(DISTINCT t.TeamName) AS TeamCount,
    COUNT(DISTINCT c.Name) AS CoachCount
FROM athletes a
LEFT JOIN entriesgender eg ON a.Discipline = eg.Discipline
LEFT JOIN teams t ON a.Discipline = t.Discipline
LEFT JOIN coaches c ON a.Discipline = c.Discipline
GROUP BY a.Discipline, eg.Female, eg.Male, eg.Total
ORDER BY TotalAthletes DESC;

-- Top performing countries (medals vs participation)
SELECT 
    m.TeamCountry,
    m.Total AS Medals,
    COUNT(DISTINCT a.PersonName) AS Athletes,
    ROUND(CAST(m.Total AS FLOAT) / NULLIF(COUNT(DISTINCT a.PersonName), 0), 2) AS MedalEfficiency,
    m.Gold,
    m.Silver,
    m.Bronze,
    m.Rank_by_Total
FROM medals m
LEFT JOIN athletes a ON m.TeamCountry = a.Country
GROUP BY m.TeamCountry, m.Total, m.Gold, m.Silver, m.Bronze, m.Rank_by_Total
HAVING COUNT(DISTINCT a.PersonName) > 0
ORDER BY MedalEfficiency DESC;

-- Participation vs Medal correlation
WITH CountryStats AS (
    SELECT 
        a.Country,
        COUNT(DISTINCT a.PersonName) AS Athletes,
        COUNT(DISTINCT a.Discipline) AS Disciplines,
        COALESCE(m.Total, 0) AS Medals,
        COALESCE(m.Rank_by_Total, 999) AS Rank
    FROM athletes a
    LEFT JOIN medals m ON a.Country = m.TeamCountry
    GROUP BY a.Country, m.Total, m.Rank_by_Total
)
SELECT 
    Country,
    Athletes,
    Disciplines,
    Medals,
    Rank,
    CASE 
        WHEN Medals = 0 THEN 'No Medals'
        WHEN Athletes > 0 THEN 
            CASE 
                WHEN CAST(Medals AS FLOAT) / Athletes > 0.5 THEN 'High Efficiency'
                WHEN CAST(Medals AS FLOAT) / Athletes > 0.2 THEN 'Medium Efficiency'
                ELSE 'Low Efficiency'
            END
        ELSE 'N/A'
    END AS PerformanceCategory
FROM CountryStats
ORDER BY Medals DESC, Athletes DESC;

-- ============================================
-- 7. SUMMARY STATISTICS
-- ============================================

-- Overall Olympics summary
SELECT 
    'Total Countries' AS Metric,
    CAST(COUNT(DISTINCT Country) AS VARCHAR) AS Value
FROM athletes
UNION ALL
SELECT 
    'Total Athletes',
    CAST(COUNT(DISTINCT PersonName) AS VARCHAR)
FROM athletes
UNION ALL
SELECT 
    'Total Disciplines',
    CAST(COUNT(DISTINCT Discipline) AS VARCHAR)
FROM athletes
UNION ALL
SELECT 
    'Total Teams',
    CAST(COUNT(DISTINCT TeamName) AS VARCHAR)
FROM teams
UNION ALL
SELECT 
    'Total Coaches',
    CAST(COUNT(DISTINCT Name) AS VARCHAR)
FROM coaches
UNION ALL
SELECT 
    'Total Medals Awarded',
    CAST(SUM(Total) AS VARCHAR)
FROM medals
UNION ALL
SELECT 
    'Total Female Participants',
    CAST(SUM(Female) AS VARCHAR)
FROM entriesgender
UNION ALL
SELECT 
    'Total Male Participants',
    CAST(SUM(Male) AS VARCHAR)
FROM entriesgender;

-- ============================================
-- 8. ADVANCED ANALYTICS
-- ============================================

-- Regional performance analysis (assuming country regions)
WITH CountryMedals AS (
    SELECT 
        m.TeamCountry,
        m.Total AS Medals,
        COUNT(DISTINCT a.PersonName) AS Athletes,
        CASE 
            WHEN m.TeamCountry IN ('USA', 'Canada', 'Mexico') THEN 'North America'
            WHEN m.TeamCountry IN ('Brazil', 'Argentina', 'Chile') THEN 'South America'
            WHEN m.TeamCountry IN ('China', 'Japan', 'South Korea', 'India') THEN 'Asia'
            WHEN m.TeamCountry IN ('Germany', 'France', 'Italy', 'UK', 'Netherlands') THEN 'Europe'
            WHEN m.TeamCountry IN ('Australia', 'New Zealand') THEN 'Oceania'
            ELSE 'Other'
        END AS Region
    FROM medals m
    LEFT JOIN athletes a ON m.TeamCountry = a.Country
    GROUP BY m.TeamCountry, m.Total
)
SELECT 
    Region,
    COUNT(DISTINCT TeamCountry) AS Countries,
    SUM(Medals) AS TotalMedals,
    SUM(Athletes) AS TotalAthletes,
    ROUND(AVG(CAST(Medals AS FLOAT)), 2) AS AvgMedalsPerCountry
FROM CountryMedals
GROUP BY Region
ORDER BY TotalMedals DESC;

-- Performance ranking with percentiles
SELECT 
    TeamCountry,
    Total AS Medals,
    Rank_by_Total,
    PERCENT_RANK() OVER (ORDER BY Total DESC) AS PercentileRank,
    NTILE(4) OVER (ORDER BY Total DESC) AS Quartile
FROM medals
ORDER BY Total DESC;


