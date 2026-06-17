USE engagement_gap;

-- =====================================================
-- Project: The Engagement Gap
-- File: 04_Audience_Sponsorship_Analysis.sql
-- Objective:
-- Analyze audience characteristics and sponsorship
-- effects to understand their influence on engagement.
-- =====================================================


-- Q1. Which Audience Locations Generate the Highest Engagement?

SELECT
    audience_location,
    ROUND(
        AVG(likes + shares + comments_count),
        2
    ) AS avg_engagement
FROM social_media_raw
GROUP BY audience_location
ORDER BY avg_engagement DESC;


-- Q2. How Does Engagement Differ Between Sponsored and Organic Posts?

SELECT
    CASE
        WHEN is_sponsored = 1 THEN 'Sponsored'
        ELSE 'Organic'
    END AS post_type,
    COUNT(*) AS total_posts,
    ROUND(
        AVG(likes + shares + comments_count),
        2
    ) AS avg_engagement
FROM social_media_raw
GROUP BY is_sponsored
ORDER BY avg_engagement DESC;


-- Q3. Which Sponsor Categories Generate the Highest Engagement?

SELECT
    sponsor_category,
    COUNT(*) AS total_posts,
    ROUND(
        AVG(likes + shares + comments_count),
        2
    ) AS avg_engagement
FROM social_media_raw
WHERE is_sponsored = 1
GROUP BY sponsor_category
ORDER BY avg_engagement DESC;


-- Q4. Do Sponsored Posts Convert Views into Engagement More Effectively?

SELECT
    CASE
        WHEN is_sponsored = 1 THEN 'Sponsored'
        ELSE 'Organic'
    END AS post_type,
    ROUND(
        AVG(
            (likes + shares + comments_count) * 100.0 /
            NULLIF(views, 0)
        ),
        2
    ) AS avg_engagement_rate
FROM social_media_raw
GROUP BY is_sponsored
ORDER BY avg_engagement_rate DESC;


-- Q5. Which Audience Gender Groups Show the Highest Engagement?

SELECT
    audience_gender_distribution,
    ROUND(
        AVG(likes + shares + comments_count),
        2
    ) AS avg_engagement
FROM social_media_raw
GROUP BY audience_gender_distribution
ORDER BY avg_engagement DESC;


-- Q6. Which Audience Age Groups Show the Highest Engagement?

SELECT
    audience_age_distribution,
    ROUND(
        AVG(likes + shares + comments_count),
        2
    ) AS avg_engagement
FROM social_media_raw
GROUP BY audience_age_distribution
ORDER BY avg_engagement DESC;


-- Q7. How Does Sponsored vs Organic Performance Differ Across Platforms?

SELECT
    platform,
    CASE
        WHEN is_sponsored = 1 THEN 'Sponsored'
        ELSE 'Organic'
    END AS post_type,
    COUNT(*) AS total_posts,
    ROUND(
        AVG(likes + shares + comments_count),
        2
    ) AS avg_engagement
FROM social_media_raw
GROUP BY platform, is_sponsored
ORDER BY platform, avg_engagement DESC;


-- Q8. Which Sponsor Categories Perform Best on Each Platform?

SELECT
    platform,
    sponsor_category,
    COUNT(*) AS total_posts,
    ROUND(
        AVG(likes + shares + comments_count),
        2
    ) AS avg_engagement
FROM social_media_raw
WHERE is_sponsored = 1
GROUP BY platform, sponsor_category
ORDER BY platform, avg_engagement DESC;