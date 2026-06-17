USE engagement_gap;

-- =====================================================
-- Project: The Engagement Gap
-- File: 06_Advanced_SQL_Analysis.sql
-- Objective:
-- Demonstrate advanced SQL techniques using CTEs,
-- window functions, rankings, and analytical queries.
-- =====================================================

-- Q1. Rank Platforms by Average Engagement Using RANK()

SELECT
platform,
ROUND(
AVG(likes + shares + comments_count),
2
) AS avg_engagement,
RANK() OVER (
ORDER BY AVG(likes + shares + comments_count) DESC
) AS platform_rank
FROM social_media_raw
GROUP BY platform;

-- Q2. Assign Dense Rankings to Content Categories

SELECT
content_category,
ROUND(
AVG(likes + shares + comments_count),
2
) AS avg_engagement,
DENSE_RANK() OVER (
ORDER BY AVG(likes + shares + comments_count) DESC
) AS category_rank
FROM social_media_raw
GROUP BY content_category;

-- Q3. Identify the Top 3 Creators Within Each Platform Using ROW_NUMBER()

WITH creator_performance AS (
SELECT
platform,
creator_name,
ROUND(
AVG(likes + shares + comments_count),
2
) AS avg_engagement,
ROW_NUMBER() OVER (
PARTITION BY platform
ORDER BY AVG(likes + shares + comments_count) DESC
) AS creator_position
FROM social_media_raw
GROUP BY platform, creator_name
)

SELECT
platform,
creator_name,
avg_engagement,
creator_position
FROM creator_performance
WHERE creator_position <= 3
ORDER BY platform, creator_position;

-- Q4. Segment Posts into Engagement Quartiles Using NTILE()

WITH engagement_segments AS (
SELECT
content_id,
platform,
(likes + shares + comments_count) AS total_engagement,
NTILE(4) OVER (
ORDER BY (likes + shares + comments_count) DESC
) AS engagement_quartile
FROM social_media_raw
)

SELECT
engagement_quartile,
COUNT(*) AS total_posts,
ROUND(
AVG(total_engagement),
2
) AS avg_engagement
FROM engagement_segments
GROUP BY engagement_quartile
ORDER BY engagement_quartile;

-- Q5. Which Platforms Dominate the Top Engagement Quartile?

WITH engagement_quartiles AS (
SELECT
platform,
NTILE(4) OVER (
ORDER BY (likes + shares + comments_count) DESC
) AS engagement_quartile
FROM social_media_raw
)

SELECT
platform,
COUNT(*) AS top_quartile_posts
FROM engagement_quartiles
WHERE engagement_quartile = 1
GROUP BY platform
ORDER BY top_quartile_posts DESC;

-- Q6. Identify the Top 5 Most Engaging Posts Across the Dataset

WITH ranked_posts AS (
SELECT
content_id,
platform,
creator_name,
(likes + shares + comments_count) AS total_engagement,
ROW_NUMBER() OVER (
ORDER BY (likes + shares + comments_count) DESC
) AS engagement_rank
FROM social_media_raw
)

SELECT
content_id,
platform,
creator_name,
total_engagement,
engagement_rank
FROM ranked_posts
WHERE engagement_rank <= 5
ORDER BY engagement_rank;
