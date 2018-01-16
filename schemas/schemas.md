#Schemas

## Introduction

Collection of things related to designing and deploying relational database schemas. These SQL queries that can be used to create tables in any tool that executes SQL commands. If you manually design/build your tables, you can usually export the SQL that would recreate them.



## Code snippets







## SQL snippets:

### Creating User table.

```



```

### Creating tables for storing arrays of Twitter entities.

```
CREATE TABLE `hashtags` (
      `tweet_id` BIGINT UNSIGNED NOT NULL DEFAULT 0                  
    , `hashtag` TEXT DEFAULT NULL                                       # entities.hashtags
    , `created_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
    , `updated_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
)    
```

```
CREATE TABLE `links` (
      `tweet_id` BIGINT UNSIGNED NOT NULL DEFAULT 0                  
    , `url` TEXT DEFAULT NULL                                            #As unwound as possible
    , `title` TEXT DEFAULT NULL                                          #HTML title  
    , `description` TEXT DEFAULT NULL                                    #HTML description          
    , `created_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
    , `updated_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
)
```

```
CREATE TABLE `native_media` (
      `tweet_id` BIGINT UNSIGNED NOT NULL DEFAULT 0                  
    , `type` TEXT DEFAULT NULL                                       # extended_entities.hashtags
    TODO
    , `created_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
    , `updated_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'  
)    
```



```
#DROP TABLE IF EXISTS hashtags; # use with caution. 
```    
