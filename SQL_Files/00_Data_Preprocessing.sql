DESCRIBE social_media_raw;

SELECT post_date
FROM social_media_raw
LIMIT 10;

ALTER TABLE social_media_raw
ADD COLUMN post_datetime DATETIME;

UPDATE social_media_raw
SET post_datetime =
STR_TO_DATE(post_date, '%c/%e/%y %h:%i %p');

SELECT post_date, post_datetime
FROM social_media_raw
LIMIT 10;