


Here is some example Ruby code that creates SQL SELECT queries:
https://github.com/jimmoffitt/SocialFlood/blob/master/EventBinner/database/tweet_sql.rb


If using MySQL, you will want to review available Data Types: https://dev.mysql.com/doc/refman/5.7/en/data-types.html


### Creating tables with SQL

See [HERE]() for example SQL for creating a 'get started' schema.

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



