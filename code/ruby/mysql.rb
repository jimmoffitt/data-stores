'''
NOTES:
Database Object. Singleton by intent, not yet by design.

One option is to use (Rails) ActiveRecord for data management, but it seems that may abstract away more than
desired.

This class is meant to demonstrate basic code for building a "database" class for use with Twitter API clients that retrieve Tweets of interest. It is written in Ruby, but in its present form hopefully will
read like pseudo-code for other languages.

Calling code needs to manage connecting and disconnecting.
'''


require "mysql2"
require "json"
require "time"
require "base64"

class DataStore
    attr_accessor :client_label, 
                  :host_label, 
                  :type_label, 
                  :port, 
                  :user_name, 
                  :password, 
                  :collection
  
    def initialize(config=nil)
        @client_label = "mysql-local"
        @host_label = "127.0.0.1"
        @type_label = "mysql-local"
        @port = 3306 #MySQL.
        @user_name = "myUserName"  
        @password = "" #Encryption needed.
        @collection = "my_tweets"

        ''' How do we want to store/access user options and credentials.
        if not config.nil? then
            getSystemConfig(config)
        end
        '''
    end

    def connect
        puts 'Connecting to datastore.'
        #MySQL
        @client = Mysql2::Client.new(:host => @host_label, :port => @port, :username => @user_name, :database => @collection )
    end
  
    def disconnect
        puts 'Closing datastore connection.'
        @client.close
    end
  
    def select(sql = nil) #needed? 
        #sql = @sql unless @sql.nil  #Do we want/need to support a static SQL statement? 
        result = @client.query(sql)
        return result #Being explicit here for readability...
    end
  
    #---------------------------------------------
    #Methods used by DataStore object creators. 
    
    def connect
        #MySQL
        @client = Mysql2::Client.new(:host => @host_label, :port => @port, :username => @user_name, :database => @collection )
    end
  
    def disconnect
        @client.close
    end
    
    def store_tweet(tweet_json)
        #Prepare SQL
        #Execute SQL
        #Provide parent success metadata
    end  

end #DataStore object

###################################################

#=======================================================================================================================
 #This script code is executed when running this file.  >ruby mysql.rb
if __FILE__ == $0 
    p "Testing database DataStore class."

    config_file = "./config/config_private.yaml"  #Default
    if config_file.nil? 
      config_details = get_config_from_file(config_file) 
    else
      config_details = get_config_from_env
    end  

    oDB = PtDB.new(config_details)
    oDB.connect
  
    #Load Tweets to store from somewhere
    tweets = get_tweet_json() #Details: inbox, outbox
  
    oDB.connect
    tweets.each do |tweet|
      oDB.store_tweet(tweet)
    end  
    
    oDB.disconnect
  
end










