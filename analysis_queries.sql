CREATE TABLE cookie_cats (
    userid INT,
    version VARCHAR(10),
    sum_gamerounds INT,
    retention_1 BOOLEAN,
    retention_7 BOOLEAN
);

SELECT COUNT(*) FROM cookie_cats;
SELECT * FROM cookie_cats LIMIT 10;
SELECT version, COUNT(*) FROM cookie_cats GROUP BY version;

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT userid) AS unique_users
FROM cookie_cats;

SELECT
    COUNT(*) FILTER (WHERE version IS NULL) AS null_version,
    COUNT(*) FILTER (WHERE sum_gamerounds IS NULL) AS null_rounds,
    COUNT(*) FILTER (WHERE retention_1 IS NULL) AS null_ret1,
    COUNT(*) FILTER (WHERE retention_7 IS NULL) AS null_ret7
FROM cookie_cats;

SELECT userid, sum_gamerounds
FROM cookie_cats
ORDER BY sum_gamerounds DESC
LIMIT 5;

SELECT
    version,
    COUNT(*) AS total_players,
    SUM(CASE WHEN retention_1 THEN 1 ELSE 0 END) AS retained_1day,
    ROUND(100.0 * SUM(CASE WHEN retention_1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS retention_1_rate,
    SUM(CASE WHEN retention_7 THEN 1 ELSE 0 END) AS retained_7day,
    ROUND(100.0 * SUM(CASE WHEN retention_7 THEN 1 ELSE 0 END) / COUNT(*), 2) AS retention_7_rate
FROM cookie_cats
WHERE userid != 6390605   
GROUP BY version
ORDER BY version;

SELECT
    version,
    COUNT(*) AS total_players,
    SUM(CASE WHEN retention_7 THEN 1 ELSE 0 END) AS retained_7day,
    ROUND(100.0 * SUM(CASE WHEN retention_7 THEN 1 ELSE 0 END) / COUNT(*), 2) AS retention_7_rate
FROM cookie_cats
WHERE userid != 6390605
GROUP BY version
ORDER BY version;

SELECT
    CASE
        WHEN sum_gamerounds <= 10 THEN '1_casual (<=10 rounds)'
        WHEN sum_gamerounds <= 50 THEN '2_regular (11-50 rounds)'
        ELSE '3_hardcore (50+ rounds)'
    END AS player_segment,
    version,
    COUNT(*) AS players,
    ROUND(100.0 * SUM(CASE WHEN retention_7 THEN 1 ELSE 0 END) / COUNT(*), 2) AS retention_7_rate
FROM cookie_cats
WHERE userid != 6390605
GROUP BY player_segment, version
ORDER BY player_segment, version;

SELECT
    CASE
        WHEN sum_gamerounds <= 10 THEN '1_casual'
        WHEN sum_gamerounds <= 50 THEN '2_regular'
        ELSE '3_hardcore'
    END AS player_segment,
    version,
    COUNT(*) AS players,
    SUM(CASE WHEN retention_7 THEN 1 ELSE 0 END) AS retained_7day
FROM cookie_cats
WHERE userid != 6390605
GROUP BY player_segment, version
ORDER BY player_segment, version;