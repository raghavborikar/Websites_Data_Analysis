use dsp505;
SELECT Website, Location 
FROM websites_data 
WHERE Location = 'India';

SELECT Website, Avg_Daily_Pageviews 
FROM unique_websites 
WHERE Avg_Daily_Pageviews > 1000000000;

SELECT Website, Facebook_likes 
FROM unique_websites 
ORDER BY Facebook_likes DESC 
LIMIT 10;

SELECT Website, Trustworthiness, Status 
FROM unique_websites 
WHERE Status = 'Risky' AND Trustworthiness = 'Excellent';

SELECT Registrar, COUNT(*) AS Website_Count 
FROM unique_websites 
GROUP BY Registrar 
ORDER BY Website_Count DESC 
LIMIT 5;

SELECT Website, (Avg_Daily_Pageviews / Avg_Daily_Visitors) AS Pageviews_Per_Visitor 
FROM unique_websites 
WHERE Avg_Daily_Visitors > 0  -- Avoid division by zero
ORDER BY Pageviews_Per_Visitor DESC 
LIMIT 10;

SELECT Website, Location, Avg_Daily_Pageviews, subnetwork_count 
FROM unique_websites AS w
WHERE subnetwork_count > 2 
  AND Avg_Daily_Pageviews > (
      SELECT MEDIAN(Avg_Daily_Pageviews) 
      FROM unique_websites 
      WHERE Location = w.Location
  );
  
WITH RankedData AS (
    SELECT 
        Location,
        Avg_Daily_Pageviews,
        ROW_NUMBER() OVER (PARTITION BY Location ORDER BY Avg_Daily_Pageviews) AS RowNum,
        COUNT(*) OVER (PARTITION BY Location) AS TotalRows
    FROM unique_websites
)
SELECT Website, Location, Avg_Daily_Pageviews, subnetwork_count
FROM unique_websites AS w
WHERE subnetwork_count > 9
  AND Avg_Daily_Pageviews > (
      SELECT AVG(Avg_Daily_Pageviews)
      FROM RankedData
      WHERE Location = w.Location
        AND (RowNum = FLOOR((TotalRows + 1) / 2) OR RowNum = CEIL((TotalRows + 1) / 2))
  );