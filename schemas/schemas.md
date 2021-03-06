# Database schemas

## Introduction

Collection of things related to designing and deploying relational database schemas. These SQL queries that can be used to create tables in any tool that executes SQL commands. If you manually design/build your tables, you can usually export the SQL that would recreate them.

Initial questions/decisions:
+ [x] Storing one Tweet ```message``` and complete entity objects: parsing code is responsible for inserting the correct version.
+ [x] Storing display text start and end, even though no plans to use it? Yes.
+ [x] Store Tweet and User IDs as strings or INTs? Storing as INTs.
+ [x] Need to add Tweet geo details. Currently storing Tweet geo in ```tweets``` table rather then a ```geo``` table. 

# Schema definitions
### SQL snippets

Below are SQL statements for creating a Tweet schema, with a main ```tweets``` table and associated tables. These are a starting point and will probably iterate when we get to actually storing Tweets. 

## Creating ```tweets``` table

```sql
CREATE TABLE `tweets` (
  `tweet_id` bigint(25) unsigned NOT NULL,
  `user_id` bigint(11) DEFAULT NULL,
  `message` varchar(300) DEFAULT NULL,
  `posted_at` datetime DEFAULT '0000-00-00 00:00:00',
  `truncated` tinyint(1) DEFAULT NULL,
  `display_text_start` tinyint(11) DEFAULT NULL,
  `display_text_end` tinyint(11) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `lang` varchar(4) DEFAULT NULL,
  `retweet_of` bigint(11) DEFAULT NULL,
  `retweeted_message` varchar(300) DEFAULT NULL,
  `quote_of` bigint(11) DEFAULT NULL,
  `quoted_message` varchar(300) DEFAULT NULL,
  `favorite_count` tinyint(4) DEFAULT NULL,
  `reply_count` tinyint(11) DEFAULT NULL,
  `retweet_count` tinyint(11) DEFAULT NULL,
  `quote_count` tinyint(11) DEFAULT NULL,
  `place_name` varchar(255) DEFAULT NULL,
  `country_code` varchar(4) DEFAULT NULL,
  `lat` decimal(9,6) DEFAULT NULL,
  `long` decimal(9,6) DEFAULT NULL,
  `lat_box` decimal(9,6) DEFAULT NULL,
  `long_box` decimal(9,6) DEFAULT NULL,
  `tweet_json` text,
  `created_at` datetime DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`tweet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

### Creating ```users```table.

```sql
CREATE TABLE `users` (
  `user_id` bigint(25) unsigned NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `handle` varchar(100) NOT NULL DEFAULT '',
  `location` varchar(100) DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `bio` varchar(255) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT '0',
  `protected` tinyint(1) DEFAULT '0',
  `followers_count` int(11) unsigned DEFAULT NULL,
  `friends_count` int(11) unsigned DEFAULT NULL,
  `listed_count` int(11) unsigned DEFAULT NULL,
  `favorites_count` int(11) unsigned DEFAULT NULL,
  `statuses_count` int(11) unsigned DEFAULT NULL,
  `posted_at` datetime DEFAULT '0000-00-00 00:00:00',
  `lang` varchar(4) DEFAULT NULL,
  `time_zone` varchar(40) DEFAULT NULL,
  `utc_offset` tinyint(6) DEFAULT NULL,
  `klout_score` tinyint(3) unsigned DEFAULT NULL,
  `country_code` varchar(4) DEFAULT NULL,
  `region` varchar(40) DEFAULT NULL,
  `sub_region` varchar(40) DEFAULT NULL,
  `locality` varchar(40) DEFAULT NULL,
  `geo_full_name` varchar(255) DEFAULT NULL,
  `lat` decimal(9,6) DEFAULT NULL,
  `long` decimal(9,6) DEFAULT NULL,
  `created_at` datetime DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

### Creating tables for storing arrays of Twitter entities.

With hashtags, we are currently maintaining an auto-incrementing 'id' primary key.

```sql
CREATE TABLE `hashtags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` bigint(25) unsigned NOT NULL DEFAULT '0',
  `hashtag` text,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4184 DEFAULT CHARSET=utf8;
```

The links table stores some super-useful URL 'data enrichments'.

```sql
CREATE TABLE `links` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` bigint(25) unsigned NOT NULL DEFAULT '0',
  `unwound_url` text,
  `display_url` text,
  `title` varchar(100) DEFAULT '',
  `description` varchar(500) DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

```sql
CREATE TABLE `mentions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` bigint(25) unsigned NOT NULL DEFAULT '0',
  `mention` varchar(20) DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

```sql
CREATE TABLE `symbols` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` bigint(25) unsigned DEFAULT NULL,
  `symbol` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

### Creating table for *Native Media*
```sql
CREATE TABLE `native_media` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` bigint(25) unsigned NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `media_id` int(11) DEFAULT NULL,
  `expanded_url` text,
  `display_url` varchar(11) DEFAULT NULL,
  `created_at` datetime DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

### Creating table for *matching rules*
```sql
CREATE TABLE `matching_rules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` bigint(25) unsigned DEFAULT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `rule_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime DEFAULT '0000-00-00 00:00:00',
  `filter` varchar(3000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

## Code snippets

Here's a method that receive an array of hashtags parsed from a collection of Tweets. 

```ruby
def write_hashtags(hashtags)

  begin

    #Build link values
    hashtag_values = []

    hashtags.each do |hashtag_metadata|
	tweet_id = hashtag_metadata['tweet_id']

	hashtag_metadata['hashtags'].each do |item|
		values = "(#{tweet_id}, '#{item['text']}', UTC_TIMESTAMP(), UTC_TIMESTAMP())"
		hashtag_values << values
	end
    end

    hashtags_number = hashtag_values.length

    #Convert array of values to a comma-delimited string.
    hashtag_values = hashtag_values.join(',')

    #Build query pattern
    sql = "REPLACE INTO hashtags (tweet_id, hashtag, created_at, updated_at)" +
	"VALUES #{hashtag_values};"

    result = @db_engine.query(sql)
    puts "Stored #{hashtags_number} hashtags..."

  rescue Exception => e
    puts "Error storing #{hashtags_number} hashtags..."
    puts e.message
    puts e.backtrace.inspect
  end

end

```

## Other details

### Tables and fields

Iterating structure with small payloads.

Iterations:
+ Drop 'id' field that was auto-incrementing primary key. Replaced with having tweet_id as primary key.
+ Tweaked table field data types. 

### Dropping tables
If you are using scripts to iterate on your schema design, the following SQL command can be used to delete any current table that is being created. So use with caution.

```
#DROP TABLE IF EXISTS hashtags; # use with caution. 
```    

### Deciding between Text and Varchar Data Types?

#### TEXT

+ fixed max size of 65535 characters (you cannot limit the max size)
+ takes 2 + c bytes of disk space, where c is the length of the stored string.
+ *cannot be part of an index*

#### VARCHAR(M)

+ variable max size of M characters
+ M needs to be between 1 and 65535
+ takes 1 + c bytes (for M ≤ 255) or 2 + c (for 256 ≤ M ≤ 65535) bytes of disk space where c is the length of the stored string
+ *can be part of an index*



