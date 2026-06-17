USE engagement_gap;

-- =====================================================
-- Project: The Engagement Gap
-- File: 05_Engagement_Gap_Analysis.sql
-- Objective:
-- Identify situations where reach fails to translate
-- into audience interaction and uncover the factors
-- behind engagement gaps.
-- =====================================================

-- Q1. Which Posts Have High Reach but Low Engagement?
-- Posts with above-average views but below-average engagement rates.

SELECT
content_id,
platform,
creator_name,
views,
(likes + shares + comments_count) AS total_engagement,
ROUND(
((likes + shares + comments_count) * 100.0) /
NULLIF(views, 0),
2
) AS engagement_rate
FROM social_media_raw
WHERE views >= (
SELECT AVG(views)
FROM social_media_raw
)
AND (
(likes + shares + comments_count) * 1.0 /
NULLIF(views, 0)
) < (
SELECT AVG(
(likes + shares + comments_count) * 1.0 /
NULLIF(views, 0)
)
FROM social_media_raw
)
ORDER BY views DESC
LIMIT 10;

-- Q2. Which Posts Have Low Reach but High Engagement?
-- Posts with below-average views but above-average engagement rates.

SELECT
content_id,
platform,
creator_name,
views,
(likes + shares + comments_count) AS total_engagement,
ROUND(
((likes + shares + comments_count) * 100.0) /
NULLIF(views, 0),
2
) AS engagement_rate
FROM social_media_raw
WHERE views < (
SELECT AVG(views)
FROM social_media_raw
)
AND (
(likes + shares + comments_count) * 1.0 /
NULLIF(views, 0)
) > (
SELECT AVG(
(likes + shares + comments_count) * 1.0 /
NULLIF(views, 0)
)
FROM social_media_raw
)
ORDER BY engagement_rate DESC
LIMIT 10;

-- Q3. Which Platforms Exhibit the Largest Engagement Gaps?
-- Platforms with lower ability to convert reach into engagement.

SELECT
platform,
ROUND(AVG(views), 2) AS avg_views,
ROUND(
AVG(likes + shares + comments_count),
2
) AS avg_engagement,
ROUND(
AVG(
(likes + shares + comments_count) * 100.0 /
NULLIF(views, 0)
),
2
) AS avg_engagement_rate
FROM social_media_raw
GROUP BY platform
ORDER BY avg_engagement_rate ASC;

-- Q4. Which Content Categories Exhibit the Largest Engagement Gaps?
-- Categories that attract visibility but generate weaker interaction.

SELECT
content_category,
ROUND(AVG(views), 2) AS avg_views,
ROUND(
AVG(likes + shares + comments_count),
2
) AS avg_engagement,
ROUND(
AVG(
(likes + shares + comments_count) * 100.0 /
NULLIF(views, 0)
),
2
) AS avg_engagement_rate
FROM social_media_raw
GROUP BY content_category
ORDER BY avg_engagement_rate ASC;

-- Q5. What Characteristics Define Highly Engaging Content?
-- Identify common traits among posts with above-average engagement.

SELECT
platform,
content_type,
content_category,
language,
CASE
WHEN content_length < 100 THEN 'Short'
WHEN content_length BETWEEN 100 AND 300 THEN 'Medium'
ELSE 'Long'
END AS content_length_group,
COUNT(*) AS total_posts,
ROUND(
AVG(likes + shares + comments_count),
2
) AS avg_engagement
FROM social_media_raw
WHERE (
likes + shares + comments_count
) >= (
SELECT AVG(likes + shares + comments_count)
FROM social_media_raw
)
GROUP BY
platform,
content_type,
content_category,
language,
CASE
WHEN content_length < 100 THEN 'Short'
WHEN content_length BETWEEN 100 AND 300 THEN 'Medium'
ELSE 'Long'
END
ORDER BY avg_engagement DESC
LIMIT 20;

-- Q6. Are Sponsored Posts More Prone to Engagement Gaps?

SELECT
CASE
WHEN is_sponsored = 1 THEN 'Sponsored'
ELSE 'Organic'
END AS post_type,
ROUND(AVG(views), 2) AS avg_views,
ROUND(
AVG(likes + shares + comments_count),
2
) AS avg_engagement,
ROUND(
AVG(
(likes + shares + comments_count) * 100.0 /
NULLIF(views, 0)
),
2
) AS avg_engagement_rate
FROM social_media_raw
GROUP BY is_sponsored
ORDER BY avg_engagement_rate ASC;

-- Q7. Which Creator Tiers Experience the Largest Engagement Gaps?

SELECT
CASE
WHEN follower_count < 10000 THEN 'Nano'
WHEN follower_count < 100000 THEN 'Micro'
WHEN follower_count < 500000 THEN 'Mid-Tier'
ELSE 'Macro'
END AS creator_tier,
COUNT(*) AS total_posts,
ROUND(AVG(views), 2) AS avg_views,
ROUND(
AVG(likes + shares + comments_count),
2
) AS avg_engagement,
ROUND(
AVG(
(likes + shares + comments_count) * 100.0 /
NULLIF(views, 0)
),
2
) AS avg_engagement_rate
FROM social_media_raw
GROUP BY
CASE
WHEN follower_count < 10000 THEN 'Nano'
WHEN follower_count < 100000 THEN 'Micro'
WHEN follower_count < 500000 THEN 'Mid-Tier'
ELSE 'Macro'
END
ORDER BY avg_engagement_rate ASC;
