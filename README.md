# data-stores
A collection of notes on and code snippets for storing Twitter data.

+ [Introduction](#intro)
  + [language/type/host combinations](#combos)
+ [Getting started material](#reading)
+ [Steps to storing Tweet data](#steps)
+ [Mapping correct JSON attributes?](#mapping)
+ [Relational databases](#relational)
  + [Designing schemas](#schema_design)
  + [Creating databases](#creating_relational)
+ [NoSQL](nosql)

# Introduction <a id="intro" class="tall">&nbsp;</a>

## Language/data-store-type/host combinations <a id="combos" class="tall">&nbsp;</a>

When writing code for storing data there are three fundamental details that determine what that code looks like. First, of course, is the *language* you are using to write the code. The second is the *type* of _data store_ you are putting your data into. The third is where your data store is *hosted*. The data store could be stored with a NoSQL datastore on your local hard drive or it may be hosted remotely in a relational database. 

### Language 
The application you are writing may focus on storing Tweets, analyzing Tweets, or displaying Tweets. You may have a Java, Scala or Node stream consumer feeding a real-time datastore. Or you may be building a historical visualization tool in Python or Ruby. Either way the language you are using to build these datastore-friendly tools likely has a set of libraries that abstract away many fundamental details. 

### Datastore type
When inserting data there are huge differences between relational databases, and "NoSQL" data stores. 

[Relational databases](https://en.wikipedia.org/wiki/Relational_database) consist of 'tables' based on a static 'schema'. Nearly all databases support the querying language SQL, although there are *dialects* depending on the database type. When inserting data into a database table, you need to first parse the Tweet JSON, extracting intities that will go into specific table 'fields'. After parsing, SQL statements that map JSON attributes to table fields are constructed. These SQL statements are then executed using a language-specific database package/library. When working with database, there is more 'getting started' effort to start *storing* data, including the important task of designing your schema.  

The phrase "[NoSQL data stores](https://en.wikipedia.org/wiki/NoSQL)" can mean a variety of things, but at their core they are made up of simple key-value pairs. When storing Tweets, these values are the individual Tweet JSON objects, and the NoSQL 'engine' uses the keys to store and retrieve these objects. NoSQL can be such a great data store solution for Tweet data precisely because it is built to store and manage JSON objects. Since all Twitter APIs return JSON objects, storing them with a NoSQL solution requires no schema design and code that exactly reflects that design. When working with NoSQL engines, there is less 'getting started' details since they readily handle JSON objects, meaning you can move quickly to storing data. However, there is likely more effort ahead when it comes to querying data. Querying code will need to encapsulate knowledge, as with the case of Tweet messages and entities, on how to navigate the JSON to read the correct attributes. 

### Host
To get started quickly, sometimes setting up a local datastore is a good way to go. Or maybe you have some internal service you can work with. In many cases you'll deploy and host a datastore using a cloud-based platform. A key assumption is that these data store systems are all reachable by IP address, and the underlying code does not care. Rather, different hosts are accessed via configuration details. 

Ruby gem connection string:
```
 @client = Mysql2::Client.new(:host => '127.0.0.1', :port => 3306, :username => 'jim', :password => 'NoMyP455w0rd', :database => 'tweets' )
```

Python package connection string:
```
cnx = mysql.connector.connect(user='jim', password='NoMyP455w0rd', host='127.0.0.1', :port => 3306, database='tweets')
```

### Options?

+ Languages? Great to start with Python, Ruby, and Node. Scala would be good too.
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
 
Given these core differences, your path to storing Tweets, and the time to get there, will be very different. If you are using a database, a first step is designing your schema, creating your tables, and constructing SQL statements for both inserting and retrieving data. If you are using a JSON data store, you can skip those steps, write some simple code for inserting the Tweet JSON, and move on to designing queries. 
 
 
## Getting started material <a id="reading" class="tall">&nbsp;</a>

A very random collection of getting started material. We should refine/expand this list as we work through new language/type/host combinations.

### NoSQL

Python
+ (https://realpython.com/blog/python/introduction-to-mongodb-and-python/)
+ (https://www.mongodb.com/blog/post/getting-started-with-python-and-mongodb)
+ (https://www.fullstackpython.com/no-sql-datastore.html)

Node
+ (https://www.npmjs.com/package/nosql)
+ (https://dzone.com/articles/nodeups-recent-podcast-nodejs)
+ (https://www.w3schools.com/nodejs/nodejs_mongodb.asp)
+ (https://www.mongodb.com/blog/post/the-mean-stack-mongodb-expressjs-angularjs-and)

Ruby
+ (https://rubygems.org/gems/mongo/versions/2.4.1)
+ (https://www.mongodb.com/events/webinar/ruby-mongodb-nov2013)


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

# Steps to store Tweet data <a id="steps" class="tall">&nbsp;</a>

+ Choose language, datastore type, and target host. 
+ Design schema and initial queries.
  + Relational database: mapping attributes and metadata "on the way in", enabling consistent querying design.
    + JSON parsing code 'knows' which attributes to grab, and can rename attributes in the process.
  + NoSQL: can just throw the JSON objects in, and build smart queries that 'know' which attributes to grab? Or 'normalize' and cherry-pick attributes on the way in?
+ Deploy data store on target host.
+ Set up development environment.
  + Install language specific data store package/gem/library.
  + Install datastore engine tool ("workbench", query UI)
+ Collect and store Tweets of interest.
  + Write code to INSERT data.
+ Start asking questions about that data. 
  + Write code to query data. (Sort of a part 2 for this project).

# Mapping correct JSON attributes? <a id="mapping" class="tall">&nbsp;</a>

With the introduction of 'hidden text' (replies and native media URLs not counted as Tweet message characters) and #280 Tweets, Tweet JSON payloads now have multiple attributes for the Tweet message and the Tweet's entities, with some of those containing incomplete and truncated values. Take this example of a #280 Tweet, [tweet_extended.json](https://github.com/jimmoffitt/data-stores/blob/master/tweets/tweet_extended.json). Using jq, let's extract the two message fields:

```
 cat tweet_extended.json | jq '.text'
  --> 'Starting a new project focused on generating code samples for storing Tweet data. So, this is an example extended T\u2026 https:\/\/t.co\/UMCKmdqOwK'
```

```
 cat tweet_extended.json | jq 'extended_tweets.full_text'
  --> 'Starting a new project focused on generating code samples for storing Tweet data. So, this is an example extended Tweet with more than 140 characters. For relational databases, the JSON parser can grab the non-truncated message field.' 
```
If you load the 'text' field as the *message* database field, you are storing the incomplete message. Your JSON parser needs to have the smarts to detect an extended Tweet, and in this case store the 'extended_tweet.full_text' into the *message* field. Luckily, this is pretty easy to do, since the 'extended_tweet' object is only there when it is an extended Tweet, and there is a 'truncated' boolean field that is always there. When 'truncated' is true the payload contains an extended Tweet.

Take this more complicated example Tweet, [tweet_rt_qt.json](https://github.com/jimmoffitt/data-stores/blob/master/tweets/tweet_rt_qt.json), which is a Retweet of a Quote Tweet. The following jq commands illustrate the multiple places in the JSON payload where Tweet/Retweet/Quote messages are provided. Which one do you need to grab? Will your JSON parser have the smarts to grab the 'right' one and INSERT it into a standardized field name such as *message*? If you are querying a NoSQL JSON collection, how does the querying code know which one to grab?

```
 cat tweet_rt_qt.json | jq '.text'
```

```
cat tweet_rt_qt.json | jq '.extended_tweet.full_text'
```

```
cat tweet_rt_qt.json | jq '.quoted_status.text'
```

```
cat tweet_rt_qt.json | jq '.quoted_status.extended_tweet.full_text'
```

```
cat tweet_rt_qt.json | jq '.retweeted_status.text'
```

```
cat tweet_rt_qt.json | jq '.retweeted_status.extended_tweet.full_text'
```

```
cat tweet_rt_qt.json | jq '.retweeted_status.quoted_status.text'
```

```
cat tweet_rt_qt.json | jq '.retweeted_status.quoted_status.extended_tweet.full_text'
```



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

If you are going the database route, you'll spend time designing the schema to store Tweet metadata. 

What questions do you want to ask of your Tweet collection? Are you curious about what languages are being used? Do you want to run statistics on what hashtags are being included? Are there certain keywords you care most about? Are you only working with Tweets that have videos? The answers to these types of questions will drive your schema design decisions.

To go deeper with schema design and deployment, see this [designing schemas discussion](https://github.com/jimmoffitt/data-stores/tree/master/schemas).


## Creating relational databases <a id="creating_relational" class="tall">&nbsp;</a>

To get started with storing data you need a deployed database to insert data into. 

### Details

+ Depending on your schema, your code that INSERTs data will probably need to support the mappings between Tweet JSON attributes and data store fields. 
  + Tweet objects can have multiple versions of fundamental details like the Tweet message and Twitter entities. 

+ Name space considerations: 
  + A common convention is to have *created_at* and *updated_at* fields in every table. These 'built-in' time fields are commonly used to build default indices and sort data, and natively support the critical ability to select records that have changed. Native Tweet JSON also uses the *created_at* name. Since you can't have duplicate field names in a given table, you may decide to store the Tweet creation time is a *posted_at* field instead.    
  + Frameworks often use the 'id' name for table primary key. If that is the case with your data store framework, then you may need to avoid adding your own (generic) primary key field. For example, when working with ActiveRecord years ago, the *tweets* table had a *tweet_id* and the *user* table had a *user_id* field. 
+ Store the entire JSON payload as a text field? Store the entire Tweet in case other parsing is needed downstream? Assume the maximum Tweet size is ~6kb?




### Creating tables with SQL

Below is an example SQL command that creates a single ```tweets``` table. While storing Tweets in a single table is not idea, this command illustrates the basic mechanics and syntax for creating tables. 


```
CREATE TABLE `tweets` (
      `tweet_id` BIGINT UNSIGNED NOT NULL DEFAULT 0                  
    , `posted_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00'       # Tweet created_at
    , `message` TEXT DEFAULT NULL                                       # Tweet message text (whitespace padded) 
    , `user_id` INT(16) UNSIGNED NOT NULL DEFAULT 0                    # numerical id  
    , `handle` CHAR(64) DEFAULT NULL 
    , `display_name` CHAR(64) DEFAULT NULL 
    
 
    #Build your INDEXs here:
    , FULLTEXT INDEX `message_idx` (`message`)  
    , INDEX `created_at_idx` (`created_at`)
    , PRIMARY KEY (tweet_id)
    
) 
ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

```

By design I want to disallow duplicate Tweet IDs, so the *tweet_id* field is set as a PRIMARY KEY. If I had no plans to use a framework that used its own reserved *id* field, I'd rename *tweet_id* to *id*, which makes for more concise queries. 


### Creating tables with Ruby ActiveRecord

ActiveRecord is a great tool for creating, maintaining, and migrating databases. Below is an example of creating a *users* table.

```
ActiveRecord::Schema.define(:version => 20170306234839) do

  create_table 'users', :force => true do |t|
    t.integer  'user_id',                 :limit => 8
   
    t.string   'display_name'
    t.string   'handle'
    t.string   'bio'
    t.string   'location'
   
    t.datetime 'created_at',                            :null => false
    t.datetime 'updated_at',                            :null => false
  end
end
```
  
Here is an example table for storing #hashtags. Such tables are recommended for all flavors of Twitter entities such as mentions, links, and media.   
  
```
  create_table 'hashtags', :force => true do |t|
    #id is maintained by ActiveRecord, enables one tweet_id being associated with multiple entities. 
    t.integer  'tweet_id', :limit => 8
    t.string   'hashtag'
    t.datetime 'created_at',               :null => false
    t.datetime 'updated_at',               :null => false
  end

```



# NoSQL datastores <a id="nosql" class="tall">&nbsp;</a>

Next!


## Mongo DB


Get started recipe:

```
mkdir py-mongo
cd py-mongo/
pip install pymongo
#brew install mongodb 
brew upgrade mongodb
sudo mongod
```

Well, that was easy enough. At least throwing in non-pre-processed Tweet JSON docs into a collection. See code [HERE](https://github.com/jimmoffitt/data-stores/blob/master/code/python/mongo.py).


### Example filters/queries:
{'user.url': {$ne : null}}




