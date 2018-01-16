


Here is some example Ruby code that creates SQL SELECT queries:
https://github.com/jimmoffitt/SocialFlood/blob/master/EventBinner/database/tweet_sql.rb


If using MySQL, you will want to review available Data Types: https://dev.mysql.com/doc/refman/5.7/en/data-types.html


### Creating tables with SQL

Below is an example SQL command that creates a single ```tweets``` table. While storing Tweets in a single table is not idea, this command illustrates the basic mechanics and syntax for creating tables. 


```
DROP TABLE IF EXISTS tweets;
CREATE TABLE `tweets` (
      `tweet_id` BIGINT UNSIGNED NOT NULL DEFAULT 0                  
    , `posted_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'       # Tweet created_at
    , `message` TEXT DEFAULT NULL                                       # Tweet message 
    
    , `payload` TEXT DEFAULT NULL                                       # Entire payload of JSON activity...?   
    , `verb` CHAR(16) DEFAULT NULL                                      # post/retweet/quote
    , `repost_of` BIGINT UNSIGNED NOT NULL DEFAULT 0                    # Retweet, Quote Tweet 

    , `lang` CHAR(8) DEFAULT NULL                                       # tweet message lang 
    , `source` CHAR(255) DEFAULT NULL                                   # service / platform
    , `link` CHAR(255) DEFAULT NULL                                     # twitter.com Tweet url 


    #Tweet geo details - Geo-tagged tweets only.
    , `place` CHAR(32) DEFAULT NULL
    , `country_code` CHAR(2) DEFAULT NULL
    , `long` DECIMAL(11,8) DEFAULT NULL                                 #Point.
    , `lat` DECIMAL(11,8) DEFAULT NULL                                  #Point.
    , `long_box` DECIMAL(11,8) DEFAULT NULL                             #If storing place bounding box.
    , `lat_box` DECIMAL(11,8) DEFAULT NULL                              #If storing place bounding box.

    #User metadata.
    , `user_id` INT(16) UNSIGNED NOT NULL DEFAULT 0                    # numerical id  
    , `handle` CHAR(64) DEFAULT NULL 
    , `displayName` CHAR(64) DEFAULT NULL 
    , `user_link` CHAR(255) DEFAULT NULL       
    , `bio` TEXT DEFAULT NULL  
    , `followers_count` INT(16) NOT NULL DEFAULT 0 
    , `friends_count` INT(16) NOT NULL DEFAULT 0 
    , `statuses_count` INT(16) NOT NULL DEFAULT 0 
    , `user_lang` CHAR(8) DEFAULT NULL  
    , `time_zone` CHAR(255) DEFAULT NULL  
    , `utc_offset` INT(16) DEFAULT NULL  
    , `user_created` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  #Actor.postedTime.    

    #User geo metadata.
    , `user_location` CHAR(64) DEFAULT NULL                           #Twitter Profile location.
    #Only needed if Profile Geo enabled.
    #These really are flattened arrays, but currently will only have one item.
    , `profile_geo_name` CHAR(128) DEFAULT NULL
    , `profile_geo_long` DECIMAL(11,8) DEFAULT NULL                              
    , `profile_geo_lat` DECIMAL(11,8) DEFAULT NULL                                  , `profile_geo_country_code`
    , `profile_geo_region` CHAR(32) DEFAULT NULL
    , `profile_geo_subregion` CHAR(32) DEFAULT NULL 
    , `profile_geo_locality` CHAR(32) DEFAULT NULL 

    , `created_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
    , `updated_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
   
    #No duplicate tweet ids!
    , PRIMARY KEY (`tweet_id`)

    #Other keys?
    #, KEY (`user_table_id`)
 
    #Build your INDEXs here:
    # , FULLTEXT INDEX `body_idx` (`body`)  
    # , INDEX `created_at_idx` (`created_at`)
) 
ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
;

```
#### Flattened arrays or separate tables?


```
    #These are flattened arrays, comma delimited (?)
    , `hashtags` CHAR(140) DEFAULT NULL                                 # symbol (e.g. cashtag) 
    , `mentions` CHAR(140) DEFAULT NULL                                 # mention (display name) 
    , `urls` TEXT DEFAULT NULL                                          # url (t.co)      # media (photo) id
    , `media` TEXT DEFAULT NULL                                         # media (photo) expanded url
    , `rule_tags` TEXT NOT NULL DEFAULT ''                              # Rules' associated tags
```

```
#DROP TABLE IF EXISTS hashtags; # use with caution. 
CREATE TABLE `hashtags` (
      `tweet_id` BIGINT UNSIGNED NOT NULL DEFAULT 0                  
    , `hashtag` TEXT DEFAULT NULL                                       # hashtag
    , `created_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
    , `updated_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
    
```

### Creating tables with Ruby ActiveRecord

ActiveRecord is a great tool for creating, maintaining, and migrating databases. Below are two examples of building additional tables for storing Twitter data.

```
ActiveRecord::Schema.define(:version => 20130306234839) do

  create_table 'users', :force => true do |t|
    t.integer  'user_id',                 :limit => 8
   
    t.string   'display_name'
    t.string   'handle'
    t.string   'bio_link'
    t.string   'bio'
    t.string   'lang'
    t.string   'time_zone'
    t.integer  'utc_offset'
    t.datetime 'posted_at'
    t.string   'location'

    t.string   'profile_geo_name'
    t.float    'profile_geo_long'
    t.float    'profile_geo_lat'
    t.string   'profile_geo_country_code'
    t.string   'profile_geo_region'
    t.string   'profile_geo_subregion'
    t.string   'profile_geo_locality'

    #compliance details - currently protected account - Need external tool to maintain metadata.
    t.boolean  'unavailable', :default => false
    t.datetime 'unavailable_at' 
   
    t.datetime 'created_at',                            :null => false
    t.datetime 'updated_at',                            :null => false
  end
end
```
  
Here is an example table for storing #hashtags. Such tables are recommended for all flavors of Twitter entities such as mentions, links, and media.   
  
```
  create_table 'hashtags', :force => true do |t|
    t.integer  'tweet_id', :limit => 8
    t.string   'hashtag'
    t.datetime 'created_at',               :null => false
    t.datetime 'updated_at',               :null => false
  end

```



