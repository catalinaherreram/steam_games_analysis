/*=========================================================
STEAM GAMES MARKET ANALYSIS
Author: Catalina Herrera
Database: DuckDB
Project: Steam Games Market Analysis

Description:
This SQL script documents the data import, preparation,
cleaning, validation, and exploratory analysis used for the
Steam Games Market Analysis portfolio project.
=========================================================*/


/*=========================================================
1. DATA IMPORT
=========================================================*/

-- Import raw CSV data into DuckDB.
-- Note: The original CSV header was manually corrected before import:
-- "DiscountDLC count" was changed to "Discount,DLC count".

CREATE OR REPLACE TABLE steam_games_raw AS
SELECT *
FROM read_csv_auto(
    '[Route.csv]',
    header = true
);


/*=========================================================
2. INITIAL DATA EXPLORATION
=========================================================*/

-- Check total number of records in the raw dataset.

SELECT
    COUNT(*) AS total_rows
FROM steam_games_raw;


-- Check coverage of the Reviews field.

SELECT
    COUNT(*) AS total_rows,
    COUNT(Reviews) AS non_null_reviews,
    COUNT(*) - COUNT(Reviews) AS null_reviews,
    ROUND(COUNT(Reviews) * 100.0 / COUNT(*), 2) AS pct_non_null
FROM steam_games_raw;


-- Create a selected view with only the variables relevant
-- to the business questions defined during the Ask phase.

CREATE OR REPLACE VIEW steam_games_selected AS
SELECT
    AppID,
    Name,
    "Release date",
    "Estimated owners",
    "Peak CCU",
    Price,
    Discount,
    "DLC count",
    Positive,
    Negative,
    Recommendations,
    "Average playtime forever",
    Developers,
    Publishers,
    Genres,
    Categories,
    Tags
FROM steam_games_raw;


-- Verify row count after selecting relevant variables.

SELECT
    COUNT(*) AS total_rows
FROM steam_games_selected;


-- Check duplicate AppIDs.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT AppID) AS unique_app_ids,
    COUNT(*) - COUNT(DISTINCT AppID) AS duplicate_app_ids
FROM steam_games_selected;


-- Check NULL values across selected columns.

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(AppID) AS null_appid,
    COUNT(*) - COUNT(Name) AS null_name,
    COUNT(*) - COUNT("Release date") AS null_release_date,
    COUNT(*) - COUNT("Estimated owners") AS null_estimated_owners,
    COUNT(*) - COUNT("Peak CCU") AS null_peak_ccu,
    COUNT(*) - COUNT(Price) AS null_price,
    COUNT(*) - COUNT(Discount) AS null_discount,
    COUNT(*) - COUNT("DLC count") AS null_dlc_count,
    COUNT(*) - COUNT(Positive) AS null_positive,
    COUNT(*) - COUNT(Negative) AS null_negative,
    COUNT(*) - COUNT(Recommendations) AS null_recommendations,
    COUNT(*) - COUNT("Average playtime forever") AS null_avg_playtime,
    COUNT(*) - COUNT(Developers) AS null_developers,
    COUNT(*) - COUNT(Publishers) AS null_publishers,
    COUNT(*) - COUNT(Genres) AS null_genres,
    COUNT(*) - COUNT(Categories) AS null_categories,
    COUNT(*) - COUNT(Tags) AS null_tags
FROM steam_games_selected;


-- Investigate records with missing Tags.

SELECT
    COUNT(*) AS total_tag_null,
    SUM(CASE WHEN Positive = 0 THEN 1 ELSE 0 END) AS positive_zero,
    SUM(CASE WHEN Negative = 0 THEN 1 ELSE 0 END) AS negative_zero,
    SUM(CASE WHEN Recommendations = 0 THEN 1 ELSE 0 END) AS recommendations_zero,
    SUM(CASE WHEN "Peak CCU" = 0 THEN 1 ELSE 0 END) AS peak_ccu_zero
FROM steam_games_selected
WHERE Tags IS NULL;


-- Compare records where Tags are available.

SELECT
    COUNT(*) AS total_tag_not_null,
    SUM(CASE WHEN Positive = 0 THEN 1 ELSE 0 END) AS positive_zero,
    SUM(CASE WHEN "Peak CCU" = 0 THEN 1 ELSE 0 END) AS peak_ccu_zero
FROM steam_games_selected
WHERE Tags IS NOT NULL;


-- Validate release date parsing.

SELECT
    COUNT(*) AS total_rows,
    COUNT(TRY_STRPTIME("Release date", '%b %d, %Y')) AS valid_dates,
    COUNT(*) - COUNT(TRY_STRPTIME("Release date", '%b %d, %Y')) AS invalid_dates
FROM steam_games_selected;


-- Validate numeric ranges.

SELECT
    MIN(Price) AS min_price,
    MAX(Price) AS max_price,
    MIN(Discount) AS min_discount,
    MAX(Discount) AS max_discount,
    MIN("Peak CCU") AS min_peak_ccu,
    MAX("Peak CCU") AS max_peak_ccu,
    MIN("Average playtime forever") AS min_playtime,
    MAX("Average playtime forever") AS max_playtime
FROM steam_games_selected;


/*=========================================================
3. DATA CLEANING AND TRANSFORMATION
=========================================================*/

-- Create the cleaned analysis table.
-- Transformations applied:
-- 1. Convert release date from text to date format.
-- 2. Create release_year and release_month fields.
-- 3. Create total_reviews.
-- 4. Create positive_review_ratio.
-- 5. Remove the single record with missing game name.

DROP TABLE IF EXISTS steam_games_clean;

CREATE TABLE steam_games_clean AS
SELECT
    AppID,
    Name,
    TRY_STRPTIME("Release date", '%b %d, %Y') AS release_date,
    YEAR(TRY_STRPTIME("Release date", '%b %d, %Y')) AS release_year,
    MONTH(TRY_STRPTIME("Release date", '%b %d, %Y')) AS release_month,
    "Estimated owners",
    "Peak CCU",
    Price,
    Discount,
    "DLC count",
    Positive,
    Negative,
    Positive + Negative AS total_reviews,
    CASE
        WHEN Positive + Negative = 0 THEN NULL
        ELSE ROUND(
            CAST(Positive AS DOUBLE) /
            (Positive + Negative),
            4
        )
    END AS positive_review_ratio,
    Recommendations,
    "Average playtime forever",
    Developers,
    Publishers,
    Genres,
    Categories,
    Tags
FROM steam_games_selected
WHERE Name IS NOT NULL;


/*=========================================================
4. CLEAN DATASET VALIDATION
=========================================================*/

-- Confirm final row count.

SELECT
    COUNT(*) AS total_games
FROM steam_games_clean;


-- Check release period.

SELECT
    MIN(release_year) AS first_year,
    MAX(release_year) AS last_year
FROM steam_games_clean;


-- Count free and paid games.

SELECT
    SUM(CASE WHEN Price = 0 THEN 1 ELSE 0 END) AS free_games,
    SUM(CASE WHEN Price > 0 THEN 1 ELSE 0 END) AS paid_games
FROM steam_games_clean;


-- Calculate average price.

SELECT
    ROUND(AVG(Price), 2) AS average_price
FROM steam_games_clean;


-- Calculate average positive review percentage.

SELECT
    ROUND(AVG(positive_review_ratio) * 100, 2) AS average_positive_review_pct
FROM steam_games_clean;


-- Review distribution summary.

SELECT
    MIN(total_reviews) AS min_reviews,
    MAX(total_reviews) AS max_reviews,
    AVG(total_reviews) AS avg_reviews,
    MEDIAN(total_reviews) AS median_reviews
FROM steam_games_clean;


-- Review count distribution.
-- This was used to define a minimum threshold of 100 reviews
-- for satisfaction-based analyses.

SELECT
    COUNT(*) AS total_games,
    SUM(CASE WHEN total_reviews = 0 THEN 1 ELSE 0 END) AS reviews_0,
    SUM(CASE WHEN total_reviews BETWEEN 1 AND 9 THEN 1 ELSE 0 END) AS reviews_1_9,
    SUM(CASE WHEN total_reviews BETWEEN 10 AND 49 THEN 1 ELSE 0 END) AS reviews_10_49,
    SUM(CASE WHEN total_reviews BETWEEN 50 AND 99 THEN 1 ELSE 0 END) AS reviews_50_99,
    SUM(CASE WHEN total_reviews BETWEEN 100 AND 499 THEN 1 ELSE 0 END) AS reviews_100_499,
    SUM(CASE WHEN total_reviews BETWEEN 500 AND 999 THEN 1 ELSE 0 END) AS reviews_500_999,
    SUM(CASE WHEN total_reviews >= 1000 THEN 1 ELSE 0 END) AS reviews_1000_plus
FROM steam_games_clean;


/*=========================================================
5. BUSINESS QUESTION 1
How has the number of game releases evolved over time?
=========================================================*/

-- Annual number of game releases.
-- The year 2026 is excluded because it represents a partial year.

SELECT
    release_year,
    COUNT(*) AS total_games
FROM steam_games_clean
WHERE release_year < 2026
GROUP BY release_year
ORDER BY release_year;


-- Share of games released between 2021 and 2025.

SELECT
    COUNT(*) AS games_2021_2025,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM steam_games_clean WHERE release_year < 2026),
        2
    ) AS pct_total
FROM steam_games_clean
WHERE release_year BETWEEN 2021 AND 2025;


/*=========================================================
6. BUSINESS QUESTION 2
Which game genres are associated with the highest player ratings?
=========================================================*/

-- Inspect distinct genre values.
-- The Genres field includes both core video game genres and other Steam classifications.

SELECT DISTINCT
    Genre
FROM (
    SELECT
        UNNEST(STRING_SPLIT(Genres, ',')) AS Genre
    FROM steam_games_clean
    WHERE Genres IS NOT NULL
) AS genre_values
ORDER BY Genre;


-- Analyze average player satisfaction by core video game genre.
-- Only games with at least 100 reviews are included.

SELECT
    Genre,
    COUNT(*) AS total_games,
    ROUND(AVG(positive_review_ratio) * 100, 2) AS avg_positive_review_pct,
    ROUND(AVG(total_reviews), 0) AS avg_total_reviews
FROM (
    SELECT
        AppID,
        total_reviews,
        positive_review_ratio,
        UNNEST(STRING_SPLIT(Genres, ',')) AS Genre
    FROM steam_games_clean
    WHERE Genres IS NOT NULL
      AND total_reviews >= 100
) AS genre_split
WHERE Genre IN (
    'Action',
    'Adventure',
    'Casual',
    'Indie',
    'RPG',
    'Simulation',
    'Strategy',
    'Sports',
    'Racing'
)
GROUP BY Genre
HAVING COUNT(*) >= 100
ORDER BY avg_positive_review_pct DESC;


/*=========================================================
7. BUSINESS QUESTION 3
Is there a relationship between price and player satisfaction?
=========================================================*/

-- Analyze player satisfaction by price range.
-- Only games with at least 100 reviews are included.

SELECT
    price_range,
    COUNT(*) AS total_games,
    ROUND(AVG(positive_review_ratio) * 100, 2) AS avg_positive_review_pct,
    ROUND(AVG(total_reviews), 0) AS avg_total_reviews
FROM (
    SELECT
        Price,
        total_reviews,
        positive_review_ratio,
        CASE
            WHEN Price = 0 THEN 'Free'
            WHEN Price < 5 THEN '$0.01-$4.99'
            WHEN Price < 10 THEN '$5-$9.99'
            WHEN Price < 20 THEN '$10-$19.99'
            WHEN Price < 40 THEN '$20-$39.99'
            WHEN Price < 60 THEN '$40-$59.99'
            ELSE '$60+'
        END AS price_range
    FROM steam_games_clean
    WHERE total_reviews >= 100
) AS price_groups
GROUP BY price_range
ORDER BY avg_positive_review_pct DESC;


-- Check number of games priced at $60 or above.

SELECT
    MAX(Price) AS max_price,
    COUNT(*) AS games_over_60
FROM steam_games_clean
WHERE Price >= 60;


/*=========================================================
8. BUSINESS QUESTION 4
Do free-to-play games receive better reviews than paid games?
=========================================================*/

-- Compare average player satisfaction between free and paid games.
-- Only games with at least 100 reviews are included.

SELECT
    price_range,
    COUNT(*) AS total_games,
    ROUND(AVG(positive_review_ratio) * 100, 2) AS avg_positive_review_pct,
    ROUND(AVG(total_reviews), 0) AS avg_total_reviews
FROM (
    SELECT
        Price,
        total_reviews,
        positive_review_ratio,
        CASE
            WHEN Price = 0 THEN 'Free'
            ELSE 'Paid'
        END AS price_range
    FROM steam_games_clean
    WHERE total_reviews >= 100
) AS price_groups
GROUP BY price_range
ORDER BY avg_positive_review_pct DESC;


/*=========================================================
9. BUSINESS QUESTION 5
Which publishers consistently release highly rated games?
=========================================================*/

-- Normalize the Publishers field.
-- Some records contain multiple publishers in one cell, separated by commas.
-- However, some legal company names also contain commas (e.g., "Inc.", "Ltd.",
-- "Co., Ltd."). To avoid splitting those legal suffixes incorrectly, common
-- legal-name commas are temporarily protected before applying STRING_SPLIT.

CREATE OR REPLACE VIEW steam_publishers_normalized AS
WITH publisher_clean AS (
    SELECT
        AppID,
        total_reviews,
        positive_review_ratio,
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(Publishers, ', Inc.', '<COMMA> Inc.'),
                    ', Ltd.', '<COMMA> Ltd.'
                ),
                ', LLC', '<COMMA> LLC'
            ),
            'Co., Ltd.', 'Co.<COMMA> Ltd.'
        ) AS publishers_protected
    FROM steam_games_clean
    WHERE Publishers IS NOT NULL
      AND total_reviews >= 100
),

publisher_split AS (
    SELECT
        AppID,
        total_reviews,
        positive_review_ratio,
        TRIM(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            UNNEST(STRING_SPLIT(publishers_protected, ',')),
                            '<COMMA> Inc.', ', Inc.'
                        ),
                        '<COMMA> Ltd.', ', Ltd.'
                    ),
                    '<COMMA> LLC', ', LLC'
                ),
                'Co.<COMMA> Ltd.', 'Co., Ltd.'
            )
        ) AS Publisher
    FROM publisher_clean
)

SELECT
    AppID,
    total_reviews,
    positive_review_ratio,
    Publisher
FROM publisher_split
WHERE Publisher IS NOT NULL
  AND Publisher <> '';


-- Explore the number of publishers by minimum qualifying game count.
-- This was used to define a threshold of at least 10 games per publisher.

SELECT
    COUNT(*) AS total_publishers,
    SUM(CASE WHEN games >= 1 THEN 1 ELSE 0 END) AS at_least_1,
    SUM(CASE WHEN games >= 5 THEN 1 ELSE 0 END) AS at_least_5,
    SUM(CASE WHEN games >= 10 THEN 1 ELSE 0 END) AS at_least_10,
    SUM(CASE WHEN games >= 20 THEN 1 ELSE 0 END) AS at_least_20
FROM (
    SELECT
        Publisher,
        COUNT(DISTINCT AppID) AS games
    FROM steam_publishers_normalized
    GROUP BY Publisher
) AS publisher_counts;


-- Distribution of publisher average ratings among publishers
-- with at least 10 qualifying games.

SELECT
    MIN(avg_positive_review_pct) AS min_avg_positive_review_pct,
    MAX(avg_positive_review_pct) AS max_avg_positive_review_pct,
    AVG(avg_positive_review_pct) AS avg_positive_review_pct,
    MEDIAN(avg_positive_review_pct) AS median_positive_review_pct
FROM (
    SELECT
        Publisher,
        COUNT(DISTINCT AppID) AS total_games,
        AVG(positive_review_ratio) * 100 AS avg_positive_review_pct
    FROM steam_publishers_normalized
    GROUP BY Publisher
    HAVING COUNT(DISTINCT AppID) >= 10
) AS publisher_ratings;


-- Count publishers considered highly rated.
-- Criteria:
-- 1. At least 10 games with 100 or more reviews.
-- 2. Average positive review ratio of at least 90%.

SELECT
    COUNT(*) AS highly_rated_publishers
FROM (
    SELECT
        Publisher,
        COUNT(DISTINCT AppID) AS total_games,
        AVG(positive_review_ratio) * 100 AS avg_positive_review_pct
    FROM steam_publishers_normalized
    GROUP BY Publisher
    HAVING COUNT(DISTINCT AppID) >= 10
       AND AVG(positive_review_ratio) * 100 >= 90
) AS publisher_summary;


-- List highly rated publishers.

SELECT
    Publisher,
    COUNT(DISTINCT AppID) AS total_games,
    ROUND(AVG(positive_review_ratio) * 100, 2) AS avg_positive_review_pct,
    ROUND(AVG(total_reviews), 0) AS avg_total_reviews
FROM steam_publishers_normalized
GROUP BY Publisher
HAVING COUNT(DISTINCT AppID) >= 10
   AND AVG(positive_review_ratio) * 100 >= 90
ORDER BY avg_positive_review_pct DESC, total_games DESC;

/*=========================================================
10. EXPORTS FOR TABLEAU
=========================================================*/

-- Export clean dataset for Tableau

COPY steam_games_clean
TO '[Route.csv]'
WITH (
    HEADER,
    DELIMITER ','
);


-- Export normalized genres dataset for Tableau

COPY (
    SELECT
        AppID,
        Name,
        UNNEST(STRING_SPLIT(Genres, ',')) AS Genre,
        positive_review_ratio,
        total_reviews
    FROM steam_games_clean
    WHERE Genres IS NOT NULL
      AND total_reviews >= 100
)
TO '[Route.csv]'
WITH (
    HEADER,
    DELIMITER ','
);


-- Export normalized top publishers dataset for Tableau

COPY (
    SELECT
        Publisher,
        COUNT(DISTINCT AppID) AS total_games,
        ROUND(AVG(positive_review_ratio) * 100, 2) AS avg_positive_review_pct,
        ROUND(AVG(total_reviews), 0) AS avg_total_reviews
    FROM steam_publishers_normalized
    GROUP BY Publisher
    HAVING COUNT(DISTINCT AppID) >= 10
       AND AVG(positive_review_ratio) * 100 >= 90
    ORDER BY avg_positive_review_pct DESC, total_games DESC
)
TO '[Route.csv]'
WITH (
    HEADER,
    DELIMITER ','
);
