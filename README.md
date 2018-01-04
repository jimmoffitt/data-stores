# data-stores
A collection of notes on and code snippets for storing Twitter data.



## Data store types

### Relational database


### NoSQL data store






## Creating databases 

### Using ActiveRecord

Having said that, the database was created (and maintained/migrated) with Rails ActiveRecord.
It is just a great way to create databases.

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

The above table fields are a bit arbitrary.  I cherry picked some Tweet details and promoted them to be table fields.
Meanwhile the entire tweet is stored, in case other parsing is needed downstream.

'''
