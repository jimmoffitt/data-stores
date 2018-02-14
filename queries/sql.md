```sql
#Counting things
SELECT COUNTS(*) FROM tweets;
SELECT COUNT(DISTINCT hashtag) FROM hashtags;
SELECT COUNT(*) FROM tweets WHERE quote_of IS NULL AND retweet_of IS NULL;

#Extended Tweets. #280. Hidden text from Simplified Mentions and Attachments.
SELECT COUNT(*) FROM tweets WHERE LENGTH(message) > 140;
SELECT COUNT(*) FROM tweets WHERE LENGTH(message) < 160 AND truncated IS FALSE;
SELECT COUNT(*) FROM tweets WHERE truncated IS FALSE;
SELECT COUNT(*) FROM tweets WHERE truncated IS TRUE;

SELECT COUNT(*) FROM tweets WHERE display_text_start IS NULL;
SELECT COUNT(*) FROM tweets WHERE display_text_start IS NOT NULL;
SELECT COUNT(*) FROM tweets WHERE display_text_start = 0;
SELECT COUNT(*) FROM tweets WHERE display_text_start > 0;
#Why do so many have this value?
SELECT COUNT(*) FROM tweets WHERE display_text_end = 127;

#Native media.
SELECT COUNT(*) FROM native_media;
SELECT COUNT(DISTINCT tweet_id) FROM native_media;

SELECT COUNT(*) FROM tweets t, native_media n
WHERE t.tweet_id = n.tweet_id;

SELECT COUNT(*) FROM tweets t, native_media n
WHERE t.tweet_id = n.tweet_id
AND n.`type` = "photo";

SELECT COUNT(*) FROM tweets t, native_media n
WHERE t.tweet_id = n.tweet_id
AND n.`type` = "video";

#Instagram links?
SELECT COUNT(*) FROM tweets t, links l
WHERE t.tweet_id = l.tweet_id
AND l.unwound_url LIKE "%instagram%";

#Top hashtags
SELECT hashtag, COUNT(*) AS total_hashtags
FROM hashtags
GROUP BY hashtag
ORDER BY total_hashtags
DESC
LIMIT 10;

#Top links
SELECT unwound_url, COUNT(*) AS total_links
FROM links
GROUP BY unwound_url
ORDER BY total_links
DESC
LIMIT 10;

#Top mentions
SELECT mention, COUNT(*) AS total_mentions
FROM mentions
GROUP BY mention
ORDER BY total_mentions
DESC
LIMIT 10;

#How many geo-tagged Tweets with native media?
SELECT COUNT(*)
FROM tweets t, native_media n
WHERE t.tweet_id = n.tweet_id
AND t.`long` IS NOT NULL;


#How many geo-tagged Tweets with  links to hosted media?
SELECT COUNT(*)
FROM tweets t, links l
WHERE t.tweet_id = l.tweet_id 
AND t.`long` IS NOT NULL
AND (l.unwound_url LIKE "%instagram%" OR l.unwound_url LIKE "%photo%");


SELECT COUNT(*) 
FROM tweets
WHERE posted_at >= CAST('2017-12-01 07:00' AS DATE)
AND posted_at < CAST('2018-01-01 07:00' AS DATE);
```

Sometimes you need to flush all of your data and start over.

```sql
DELETE FROM users;
DELETE FROM tweets;
DELETE FROM hashtags;
DELETE FROM mentions;
DELETE FROM links;
DELETE FROM native_media;
DELETE FORM matching_rules;

```
