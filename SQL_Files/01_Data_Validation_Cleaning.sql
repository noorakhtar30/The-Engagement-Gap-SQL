USE engagement_gap;
-- =====================================================
-- Project: The Engagement Gap
-- File: 00_Data_Validation_Cleaning.sql

-- =====================================================


-- Q1. how many records are available for analysis?
SELECT COUNT(*) AS total_records
FROM social_media_raw;

-- Q2. Duplicate ID Check
SELECT
    id,
    COUNT(*) AS duplicate_count
FROM social_media_raw
GROUP BY id
HAVING COUNT(*) > 1;


-- Q3. Duplicate Content ID Check

SELECT
    content_id,
    COUNT(*) AS duplicate_count
FROM social_media_raw
GROUP BY content_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Q4. NULL Value Check for Important Columns

SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_id,
    SUM(CASE WHEN content_id IS NULL THEN 1 ELSE 0 END) AS null_content_id,
    SUM(CASE WHEN platform IS NULL THEN 1 ELSE 0 END) AS null_platform,
    SUM(CASE WHEN creator_id IS NULL THEN 1 ELSE 0 END) AS null_creator_id,
    SUM(CASE WHEN post_datetime IS NULL THEN 1 ELSE 0 END) AS null_post_datetime,
    SUM(CASE WHEN views IS NULL THEN 1 ELSE 0 END) AS null_views,
    SUM(CASE WHEN likes IS NULL THEN 1 ELSE 0 END) AS null_likes,
    SUM(CASE WHEN shares IS NULL THEN 1 ELSE 0 END) AS null_shares,
    SUM(CASE WHEN comments_count IS NULL THEN 1 ELSE 0 END) AS null_comments_count,
    SUM(CASE WHEN follower_count IS NULL THEN 1 ELSE 0 END) AS null_follower_count,
    SUM(CASE WHEN is_sponsored IS NULL THEN 1 ELSE 0 END) AS null_is_sponsored
FROM social_media_raw;

-- Q5. Distinct Platforms

SELECT DISTINCT platform
FROM social_media_raw
ORDER BY platform;

-- Q6. Distinct Content Types

SELECT DISTINCT content_type
FROM social_media_raw
ORDER BY content_type;

-- Q7. Distinct Content Categories

SELECT DISTINCT content_category
FROM social_media_raw
ORDER BY content_category;

-- Q8. Distinct Languages

SELECT DISTINCT language
FROM social_media_raw
ORDER BY language;

-- Q9. Distinct Audience Locations

SELECT DISTINCT audience_location
FROM social_media_raw
ORDER BY audience_location;

-- Q10. Sponsored vs Organic Post Counts

SELECT
    CASE
        WHEN is_sponsored = 1 THEN 'Sponsored'
        WHEN is_sponsored = 0 THEN 'Organic'
    END AS post_type,
    COUNT(*) AS post_count
FROM social_media_raw
GROUP BY is_sponsored;

-- Q11. Date Range of Posts

SELECT
    MIN(post_datetime) AS earliest_post,
    MAX(post_datetime) AS latest_post
FROM social_media_raw;

-- Q12. Minimum and Maximum Views

SELECT
    MIN(views) AS minimum_views,
    MAX(views) AS maximum_views
FROM social_media_raw;



-- Q13. Minimum and Maximum Likes

SELECT
    MIN(likes) AS minimum_likes,
    MAX(likes) AS maximum_likes
FROM social_media_raw;

-- Q14. Minimum and Maximum Follower Counts

SELECT
    MIN(follower_count) AS minimum_followers,
    MAX(follower_count) AS maximum_followers
FROM social_media_raw;

-- Q15. Basic Data Sanity Checks

SELECT
    SUM(CASE WHEN views < 0 THEN 1 ELSE 0 END) AS negative_views,
    SUM(CASE WHEN likes < 0 THEN 1 ELSE 0 END) AS negative_likes,
    SUM(CASE WHEN shares < 0 THEN 1 ELSE 0 END) AS negative_shares,
    SUM(CASE WHEN comments_count < 0 THEN 1 ELSE 0 END) AS negative_comments,
    SUM(CASE WHEN follower_count < 0 THEN 1 ELSE 0 END) AS negative_followers,
    SUM(CASE WHEN likes > views THEN 1 ELSE 0 END) AS likes_exceed_views,
    SUM(CASE WHEN shares > views THEN 1 ELSE 0 END) AS shares_exceed_views,
    SUM(CASE WHEN comments_count > views THEN 1 ELSE 0 END) AS comments_exceed_views
FROM social_media_raw;



