# data-stores
A collection of notes on and code snippets for storing Twitter data.

+ [Introduction](#intro)
  + [language/type/host combinations](#combos)
+ [Getting started material](#reading)
+ [Relational databases](#relational)
  + [Designing schemas](#schema_design)
  + [Creating databases](#creating_relational)

# Introduction <a id="intro" class="tall">&nbsp;</a>

Developers are drawn to Twitter data because of 

## Language/data-store-type/host combinations <a id="combos" class="tall">&nbsp;</a>

When writing code for storing data there are three fundamental details that determine what that code looks like. First, of course, is the *language* you are using to write the code. The second is the *type* of _data store_ you are putting your data into. The third is where your data store is *hosted*. The data store could be stored with a NoSQL datastore on your local hard drive or it may be hosted remotely in a relational database. 

Language 
The application you are writing may focus on storing Tweets, analyzing Tweets, or displaying Tweets

When inserting data there are huge differences between relational databases, and "NoSQL" data stores. 

[Relational databases](https://en.wikipedia.org/wiki/Relational_database) consist of 'tables' based on a static 'schema'. Nearly all databases support the querying language SQL, although there are *dialects* depending on how the database type. When inserting data into a database table, you need to first parse the Tweet JSON, extracting intities that will go into a specific table 'field'. After parsing, SQL statements that map JSON attributes to table fields are constructed. These SQL statements are then executed using a language-specific database package/library.

The phrase "[NoSQL data stores](https://en.wikipedia.org/wiki/NoSQL)" can mean a variety of things, but at their core they are made up of simple key-value pairs. When storing Tweets, these values are the individual Tweet JSON objects, and the NoSQL 'engine' uses the keys to store and retrieve these objects. NoSQL can be such a great data store solution for Tweet data precisely because it is built to store and manage JSON objects. Since all Twitter APIs return JSON objects, storing them with a NoSQL solution requires no schema design and code that exactly reflects that design. 

Given these core differences, your path to storing Tweets, and the time to get there, will be very different. If you using a database, a first step is designing your schema, creating your tables, and constructing SQL statements for both inserting and retrieving data. If you are using a JSON data store, you can skip those steps, write some simple code for inserting the Tweet JSON, and move on to designing queries.


### Options

+ Languages? Great to start with Python, Ruby, Node, and Scala.
+ Data store types? 
  + [Relational databases](https://en.wikipedia.org/wiki/Relational_database): schema/table based. MySQL, PostgreSQL, SQLite, SQL Server
  + [NoSQL data stores](https://en.wikipedia.org/wiki/NoSQL): schema-less JSON collections. MongoDB, DynamoDB (AWS), Domino (IBM)
+ Hosts
  + Local: running on a local (laptop) server environment.
  + Internal-service: connecting to an intenal data store host/service.
  + Cloud services: AWS, Google Cloud, Azure
  + Developer platforms: Heroku, Glitch

### Examples
+ python / nosql / local 
+ python / mysql / local
+ ruby / nosql / AWS 
+ ruby / mysql/ vpn-internal 
+ node / nosql / Google Cloud

### Assumptions
+ Relational database code will readily port to other db engines.
  + Default: MySQL. Other targets: Postgres, sqlite, SQL Server
+ NoSQL code will readily port to other engines.
  + Default: Mongo DB. Other targets: Amazon, other cloud dialects. 
 
## Getting started material <a id="reading" class="tall">&nbsp;</a>

A very random collection of getting started material. We should refine/expand this list as we work through new language/type/host combinations.

### NoSQL

Python
+ (https://realpython.com/blog/python/introduction-to-mongodb-and-python/)
+ (https://www.mongodb.com/blog/post/getting-started-with-python-and-mongodb)
+ (https://www.fullstackpython.com/no-sql-datastore.html)

Node
+ (https://www.npmjs.com/package/nosql)
+ (https://dzone.com/articles/nodeups-recent-podcast-nodejs
+ (https://www.w3schools.com/nodejs/nodejs_mongodb.asp
+ (https://www.mongodb.com/blog/post/the-mean-stack-mongodb-expressjs-angularjs-and

Ruby
+ (https://rubygems.org/gems/mongo/versions/2.4.1
+ (https://www.mongodb.com/events/webinar/ruby-mongodb-nov2013


### Relational databases

Python
+ (https://www.datacamp.com/courses/introduction-to-relational-databases-in-python)
+ (https://www.fullstackpython.com/databases.html)
+ (https://dataset.readthedocs.io/en/latest/) <-- interesting concept that blends the NoSQL schema-less world with relational databases.
+ (https://dev.mysql.com/doc/connector-python/en/)

Node
+ (https://www.slant.co/topics/5218/~relational-databases-to-use-for-node-js-applications)
+ (https://blog.risingstack.com/node-js-database-tutorial/)

Ruby
+ (http://rubylearning.com/satishtalim/ruby_mysql_tutorial.html)
+ (http://guides.rubyonrails.org/active_record_basics.html)
+ (http://backend.turing.io/module2/lessons/intro_to_active_record_in_sinatra)


# Relational databases <a id="relational" class="tall">&nbsp;</a>

When deciding to store data in a relational database, some first steps include:
  + Identify initial queries - Based on your use cases, what questions to you want to ask about your Tweets of interest? Does your research involve hashtags? Are there user public attributes of interest? Does your use case beniefit from geo-referencing Twitter conversations? 
  + Design schema - Cherry-picking Tweet JSON attributes of interest. An opportunity to drop or transform attributes:
    + Within Tweet objects there are both truncated and complete Tweet message text fields. You will likely *teach* your parsing code to correctly navigate Tweet JSON and always provide a single, *complete* Tweet message for storage. For example, classic Tweet messages (140 or less characters) are provided in one 'text' JSON attribute, while complete #280 Tweet messages are provided in a 'extended_tweet.full_text' attribute, while a 'text' attribute remains that contains a truncated message.
    + You many not care about user profile color themes, so you can ignore those JSON attributes. 
  + Deploy database - Whether you are deploying locally or on the cloud, you need to start a database engine and confirm you can connect and query it.
  + Pick a database IDE - Most database engines provide a UI-driven tool for managing databases. Ideally, these help you monitor and manage connections, and provide a query interface.
  + Load and query data - The reason we started this adventure. Now we've automated the stored of Tweet of interest, and can rapidly ask questions about that data. 

Material here will focus on the intersection of Tweet data and two fundamental database design details: queries of interest and designing schemas. We store Tweet data to explore our use cases of interest, and those use cases drive the type of metadata we need to store for our analysis, visualizations, and archival. 

In some atypical schemes, you may decide to store only the Tweet ID, which is a Tweet primary key attribute. With this ID you can use other Twitter APIs to 'rehydrate' the other Tweet metadata. 

More commonly, additional metadata are stored, such as the Tweet *message*, when it was posted, by who, and common Twitter *entities* such as hashtags, links, and mentions. 


```
sql = "INSERT INTO tweets (id, posted_at, message, user_id, created_at, updated_at ) " +
                 "VALUES (#{id_str}, '#{created_at}', '#{message}', #{user_id}, UTC_TIMESTAMP(), UTC_TIMESTAMP());"
```
*Note* that database engines may provide additional methods for inserting data. For example, INSERT is standard SQL, and MySQL supports a REPLACE method that ignores duplicates and updates any existing data. 



## Designing schemas <a id="schema_design" class="tall">&nbsp;</a>

What questions do you want to ask of your Tweet collection? Are you curious about what languages are being used? Do you want to run statistics on what hashtags are being included? Are there certain keywords you care most about? Are you only working with Tweets that have videos? The answers to these types of questions will drive your schema design decisions.




Here is some example Ruby code that creates SQL SELECT queries:
https://github.com/jimmoffitt/SocialFlood/blob/master/EventBinner/database/tweet_sql.rb



## Creating relational databases <a id="creating_relational" class="tall">&nbsp;</a>

These table fields are a bit arbitrary.  I cherry picked some Tweet details and promoted them to be table fields.
Meanwhile the entire tweet is stored, in case other parsing is needed downstream.

### Using SQL

Below is an example SQL command that creates a single ```tweets``` table. While storing Tweets in a single table is not idea, this command illustrates the basic mechanics and syntax for creating tables. 


```
DROP TABLE IF EXISTS tweets;
CREATE TABLE `tweets` (
      `tweet_id` BIGINT UNSIGNED NOT NULL DEFAULT 0                  
    , `posted_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'       # Tweet created_at
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

### Using Ruby ActiveRecord

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




