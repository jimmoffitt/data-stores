### Collection of example SQL queries based on the schema HERE.

```sql



#Counting things
SELECT COUNT(*) FROM tweets;
#Original Tweets
SELECT COUNT(*) FROM tweets WHERE quote_of IS NULL AND retweet_of IS NULL;
#Quote Tweets
SELECT COUNT(*) FROM tweets WHERE quote_of IS NOT NULL;
#Retweets
SELECT COUNT(*) FROM tweets WHERE retweet_of IS NOT NULL;

SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM hashtags;
#Unique hashtags.
SELECT COUNT(DISTINCT hashtag) FROM hashtags;

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

#Tweets with native photos
SELECT COUNT(*) FROM tweets t, native_media n
WHERE t.tweet_id = n.tweet_id
AND n.`type` = "photo";

#Tweets with native videos
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

#Most frequent posters?
SELECT u.handle, COUNT(*) AS total_tweets
FROM tweets t, users u
WHERE t.user_id = u.user_id
GROUP BY u.user_id
ORDER BY total_tweets
DESC
LIMIT 30;

#How many geo-tagged Tweets with native media?
SELECT COUNT(*)
FROM tweets t, native_media n
WHERE t.tweet_id = n.tweet_id
AND t.`long` IS NOT NULL;

#How many geo-tagged Tweets with links to hosted media? Any link with "photo" or "instagram" tokens.
SELECT COUNT(*)
FROM tweets t, links l
WHERE t.tweet_id = l.tweet_id 
AND t.`long` IS NOT NULL
AND (l.unwound_url LIKE "%instagram%" OR l.unwound_url LIKE "%photo%");


### OTHERS


#Tweets from specified time period
SELECT COUNT(*) 
FROM tweets
WHERE posted_at >= CAST('2017-12-01 07:00' AS DATE)
AND posted_at < CAST('2018-01-01 07:00' AS DATE);

#Filters driving this dataset
SELECT DISTINCT filter
FROM matching_rules;

#Exporting Tweet IDs for Engagement API
SELECT tweet_id FROM tweets;

#Time-series generation.
SELECT FROM_UNIXTIME(CEILING(UNIX_TIMESTAMP(t.`posted_at`))) AS timeslice,
       COUNT(*) AS mycount
FROM tweets t, hashtags h
WHERE t.tweet_id = h.tweet_id AND (h.hashtag LIKE "%fire%")
GROUP BY timeslice;


```

### Purging your database's data
Sometimes you need to flush all of your data and start over.

```sql
DELETE FROM users;
DELETE FROM tweets;
DELETE FROM hashtags;
DELETE FROM mentions;
DELETE FROM symbols;
DELETE FROM links;
DELETE FROM native_media;
DELETE FROM matching_rules;
```

### Queries to set VIT Tweets in bulk:

```sql
UPDATE tweets t, users u
SET t.`vit` = 1
WHERE u.handle IN ("CountyVentura", "CAL_FIRE", "venturawaterCA", "VCFD", "VCWatershed","VenturaOES","NWSLosAngeles", "countyofSB", "CaltransDist7")
AND t.user_id = u.user_id;

#Some account are conditional VIT
UPDATE tweets t, users u
SET t.`vit` = 1
WHERE u.handle IN ("VCscanner", "LATimes")
AND t.message LIKE "%fire%"
AND t.message LIKE "%thomas%"
AND t.posted_at > '2017-12-04 19:00:00' 
AND t.user_id = u.user_id;

##Looking for conversations
SELECT COUNT(*) FROM tweets
WHERE (message LIKE "%need%" AND message LIKE "%rescue%");

SELECT * FROM tweets
WHERE (message LIKE "%need%" AND message LIKE "%rescue%")
LIMIT 1000;

SELECT COUNT(*) FROM tweets
WHERE (message LIKE "@VCFD%");

SELECT * FROM tweets
WHERE (message LIKE "@VCFD%")
LIMIT 1000;



```

Example queries for curating 'by hand':

```sql
SELECT posted_at,message, vit 
FROM tweets
WHERE message LIKE "%help%" 
AND message LIKE "%rescue%" ;

SELECT posted_at,message, vit 
FROM tweets
WHERE message LIKE "%address%"
AND message LIKE "%rescue%" ;





```
