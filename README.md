# data-stores
A collection of notes on and code snippets for storing Twitter data.



## Data store types

### Relational database


### NoSQL data store






## Creating databases 

### Using SQL

Below is an example SQL command that creates a single ```tweets``` table. While storing Tweets in a single table is not idea, this command illustrates the basic mechanics and syntax for creating tables. 


```
DROP TABLE IF EXISTS tweets;
CREATE TABLE `tweets` (
      `tweet_id` BIGINT UNSIGNED NOT NULL DEFAULT 0                  
    , `created_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'       # Tweet created_at
    , `body` TEXT DEFAULT NULL                                          # activity body text (whitespace padded) 
    
    , `payload` TEXT DEFAULT NULL                                       #Entire payload of JSON activity...?   
    , `verb` CHAR(16) DEFAULT NULL                                      # post/share/compliance 
    , `repost_of` BIGINT UNSIGNED NOT NULL DEFAULT 0                    #retweet 

    , `twitter_lang` CHAR(8) DEFAULT NULL                               # tweet body lang (tw) 
    , `generator` CHAR(255) DEFAULT NULL                                # service / platform
    , `link` CHAR(255) DEFAULT NULL                                     # www activity location url 

    #These are flattened arrays, comma delimited (?)
    , `hashtags` CHAR(140) DEFAULT NULL                                 # symbol (e.g. cashtag) 
    , `mentions` CHAR(140) DEFAULT NULL                                 # mention (display name) 
    , `urls` TEXT DEFAULT NULL                                          # url (t.co)      # media (photo) id
    , `media` TEXT DEFAULT NULL                                         # media (photo) expanded url
    , `rule_values` TEXT NOT NULL DEFAULT ''                            # Rule/filter that returned this data
    , `rule_tags` TEXT NOT NULL DEFAULT ''                              # Rules' associated tags

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

### Using ActiveRecord

Having said that, the database was created (and maintained/migrated) with Rails ActiveRecord.
It is just a great way to create databases.

```
ActiveRecord::Schema.define(:version => 20130306234839) do

  create_table "activities", :force => true do |t|
    t.integer  "native_id",   :limit => 8
    t.text     "content"
    t.text     "body"
    t.string   "rule_value"
    t.string   "rule_tag"
    t.string   "publisher"
    t.string   "job_uuid"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "posted_time"
  end

end
```

The above table fields are a bit arbitrary.  I cherry picked some Tweet details and promoted them to be table fields.
Meanwhile the entire tweet is stored, in case other parsing is needed downstream.


