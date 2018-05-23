=begin

This class knows how to write Tweets to a relational database.

Client code makes a call to Relational.store_tweets(results), where 'results' is the response['results'] hash/dictionary
as returned from any of the Twitter premium and enterprise search APIs.

This class knows how navigate and transform Tweet JSON to provide the correct (e.g. complete) message, entities and extended_entities
attributes. This transformation results in root-level entities and extended entities objects that are correct, regardless of whether 
the Tweet is 'extended' (> 140 characters) or not. So, this class abstracts the 'extended' Tweet details away at the INSERT/Schema 
evel. This transformation also includes generating a root-level 'message' attribute that contains a non-trunctated Tweet message.  

The SQL commands generated here are based on [this schema](https://github.com/jimmoffitt/data-stores/blob/master/schemas/schemas.md).

=end

class Relational

	require 'mysql2'
	require 'json'
	require 'time'

	attr_accessor :host,                 # Where datastore is hosted. local, internal, or on the cloud.
	              :port,                 # Common defaults: MySQL: 3306, MongoDB: ?, SQL Server 1433, PostgreSQL: 5432
	              :credentials,          # Flexible hash that holds datastore-specific creds for connection authentication.
	              # Most datastores have username and passwords, but should anticipate using keys and tokens.
	              :database,           # For relational databases, this is the *schema* or *database* name.
	              # For NoSQL datastores, this is the "collection" name. A Folder of Tweets.
	              :connected,            # Enables client app to confirm state.
	              :engine

	def initialize(host=nil, port=nil, credentials=nil, database=nil)
		@connected = false
		@use_ssh = true
			
		
		#Hardcoded now, will be configured.
		@host = '127.0.0.1' #floods.rw.ss-001.smf1.db.twitter.biz'
		@port = 3307  #3306   #Note: this is a local port, and if SSHing to a remote server, may be set under the hood:
		               #ssh -N -f -L 3307:<DB-HOST-NAME>:3306 <nest server>
		@database = 'floods'
		@ssh_host = 'nest.smfc.twitter.com'
		
		@credentials = {}
		@credentials['username'] = ''
		@credentials['password'] = ''

    #Let's connect
		connect

	end

	def batch_write_hashtags(hashtags)

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
			hashtag_values = hashtag_values.join(",")

			#Build query pattern
			sql = "REPLACE INTO hashtags (tweet_id, hashtag, created_at, updated_at)" +
				"VALUES #{hashtag_values};"
			
			result = @engine.query(sql)
			puts "Stored #{hashtags_number} hashtags..."

		rescue Exception => e
			puts "Error storing #{hashtags_number} hashtags..."
			puts e.message
			puts e.backtrace.inspect
		end

	end
	
	def batch_write_links(links)
		begin

			#Build link values
			link_values = []

			links.each do |link_metadata|
				tweet_id = link_metadata['tweet_id']
				
				link_metadata['links'].each do |item|
					values = "(#{tweet_id}, '#{item['unwound']['url']}' , '#{item['display_url']}', '#{item['unwound']['title']}', '#{item['unwound']['description']}', UTC_TIMESTAMP(), UTC_TIMESTAMP())"
					link_values << values
				end
			end
			
			links_number = link_values.length

			#Convert array of values to a comma-delimited string.
			link_values = link_values.join(",")

			#Build query pattern
			sql = "REPLACE INTO links (tweet_id,  unwound_url, display_url, title, description, created_at, updated_at)" +
				"VALUES #{link_values};"
	
		
			result = @engine.query(sql)
			puts "Stored #{links_number} links..."

		rescue Exception => e
			puts "Error storing #{links_number} links..."
			puts e.message
			puts e.backtrace.inspect
		end
	end
	
	def batch_write_mentions(mentions)

		begin

			#Build link values
			mention_values = []

			mentions.each do |mention_metadata|
				tweet_id = mention_metadata['tweet_id']

				mention_metadata['mentions'].each do |item|
					values = "(#{tweet_id}, '#{item['text']}', UTC_TIMESTAMP(), UTC_TIMESTAMP())"
					mention_values << values
				end
			end

			mentions_number = mention_values.length

			#Convert array of values to a comma-delimited string.
			mention_values = mention_values.join(",")

			#Build query pattern
			sql = "REPLACE INTO mentions (tweet_id, mention, created_at, updated_at)" +
				"VALUES #{mention_values};"
			
			result = @engine.query(sql)
			puts "Stored #{mentions_number} mentions..."

		rescue Exception => e
			puts "Error storing #{mentions_number} mentions..."
			puts e.message
			puts e.backtrace.inspect
		end

	end

	def batch_write_symbols(symbols)

		begin

			#Build link values
			symbol_values = []

			symbols.each do |symbol_metadata|
				tweet_id = symbol_metadata['tweet_id']

				symbol_metadata['symbols'].each do |item|
					values = "(#{tweet_id}, '#{item['text']}', UTC_TIMESTAMP(), UTC_TIMESTAMP())"
					symbol_values << values
				end
			end

			symbols_number = symbol_values.length

			#Convert array of values to a comma-delimited string.
			symbol_values = symbol_values.join(",")

			#Build query pattern
			sql = "REPLACE INTO symbols (tweet_id, symbol, created_at, updated_at)" +
				"VALUES #{symbol_values};"
			
			result = @engine.query(sql)
			puts "Stored #{symbols_number} symbols..."
				
		rescue Exception => e
			puts "Error storing #{symbols_number} symbols..."
			puts e.message
			puts e.backtrace.inspect
		end

	end

	def batch_write_native_media(media)
		begin

			#Build link values
			media_values = []

			media.each do |media_metadata|
				tweet_id = media_metadata['tweet_id']

				media_metadata['media'].each do |item|
					values = "(#{tweet_id}, '#{item['type']}' , '#{item['id']}', '#{item['expanded_url']}', '#{item['display_url']}', UTC_TIMESTAMP(), UTC_TIMESTAMP())"
					media_values << values
				end
			end

			media_number = media_values.length

			#Convert array of values to a comma-delimited string.
			media_values = media_values.join(",")

			#Build query pattern
			sql = "REPLACE INTO native_media (tweet_id, `type`, media_id, expanded_url, display_url, created_at, updated_at)" +
				"VALUES #{media_values};"

			result = @engine.query(sql)
			puts "Stored metadata for #{media_number} Twitter-native photos and vidoes..."

		rescue Exception => e
			puts "Error storing #{links_number} links..."
			puts e.message
			puts e.backtrace.inspect
		end
	end
	
	def batch_write_users (users)

		begin
			#Build user values
			user_values = []

			users.each do |user|
				values = "(#{user['id']}, '#{user['name']}', '#{user['screen_name']}', '#{user['location']}', '#{user['url']}', '#{user['bio']}', #{user['verified']}, #{user['protected']}, '#{Time.parse(user['created_at']).strftime("%Y-%m-%d %H:%M:%S")}',
                     #{user['followers_count']}, #{user['friends_count']}, #{user['listed_count']}, #{user['favourites_count']}, #{user['statuses_count']},
                     '#{user['lang']}', '#{user['time_zone']}', #{user['utc_offset']}, #{user['klout_score']}, '#{user['country_code']}', '#{user['region']}', '#{user['sub_region']}', '#{user['locality']}',
                     '#{user['geo_full_name']}', #{user['lat']}, #{user['long']}, UTC_TIMESTAMP(), UTC_TIMESTAMP())"

				user_values << values
			end

			#Convert array of values to a comma-delimited string.
			user_values = user_values.join(",")

			#Build query pattern
			sql = "REPLACE INTO users (user_id, name, handle, location, url, bio, verified, protected, posted_at,
                                 followers_count, friends_count, listed_count, favorites_count, statuses_count,
                                 lang, time_zone, utc_offset, klout_score, country_code, region, sub_region, locality,
                                 geo_full_name, lat, `long`, created_at, updated_at)" + 
                "VALUES #{user_values};"
			
			result = @engine.query(sql)
			puts "Stored #{users.length} users..."

		rescue Exception => e
			puts "Error storing #{users.length} users..."
			puts e.message
			puts e.backtrace.inspect
		end
	end
	
	def batch_write_tweets(tweets)
		
		begin 
			#Build Tweet values
			tweet_values = []
			
			tweets.each do |tweet|
				values = "(#{tweet['id']}, #{tweet['user']['id']}, '#{tweet['message']}', '#{Time.parse(tweet['created_at']).strftime("%Y-%m-%d %H:%M:%S")}',
					#{tweet['truncated']}, #{tweet['display_text_start']}, #{tweet['display_text_end']}, '#{tweet['source']}',
				'#{tweet['lang']}',  #{tweet['retweet_of']}, '#{tweet['retweeted_message']}', #{tweet['quote_of']}, '#{tweet['quoted_message']}',
				              #{tweet['favorite_count']}, #{tweet['reply_count']}, #{tweet['retweet_count']}, #{tweet['quote_count']},
				              '#{tweet['place_name']}', '#{tweet['country_code']}', #{tweet['lat']}, #{tweet['long']}, #{tweet['lat_box']}, #{tweet['long_box']},UTC_TIMESTAMP(), UTC_TIMESTAMP())"

				tweet_values << values
			end

			#Convert array of values to a comma-delimited string.
			tweet_values = tweet_values.join(",")
	
			#Build query pattern
			sql = "REPLACE INTO tweets (tweet_id, user_id, message, posted_at, truncated, display_text_start, display_text_end,
		                                source, lang, retweet_of, retweeted_message, quote_of, quoted_message, favorite_count,
		                                reply_count, retweet_count, quote_count, place_name, country_code, lat, `long`, lat_box, long_box, created_at, updated_at ) " +
				     "VALUES #{tweet_values};"
			
			result = @engine.query(sql)
			puts "Storing #{tweets.length} Tweets..."

		rescue Exception => e
			puts "Error storing #{tweets.length} Tweets..."
			puts e.message
			puts e.backtrace.inspect
		end
	end

	def transform_link_objects(links)
		begin
			links.each do |link|
				#link['unwound']['title'] = link['unwound']['title'].gsub("'", %q(\\\')) if !link['unwound']['title'].nil?
				#link['unwound']['title'] = link['unwound']['title'].gsub("’", "") if !link['unwound']['title'].nil?
				#link['unwound']['title'] = link['unwound']['title'].gsub("\\", "") if !link['unwound']['title'].nil?

				link['unwound']['title'] = @engine.escape(link['unwound']['title']) if !link['unwound']['title'].nil?
				
				#link['unwound']['description'] = link['unwound']['description'].gsub("'", %q(\\\')) if !link['unwound']['description'].nil?
				#link['unwound']['description'] = link['unwound']['description'].gsub("’", "") if !link['unwound']['description'].nil?
				#link['unwound']['description'] = link['unwound']['description'].gsub("\\", "") if !link['unwound']['description'].nil?

				link['unwound']['description'] = @engine.escape(link['unwound']['description']) if !link['unwound']['description'].nil?
			end
		rescue Exception => e
			puts e.message
			puts e.backtrace.inspect
			puts 'stop'
		end

		return links

	end

	def transform_user_object(user)

		begin #User attributes.
			
			#user['name']	= user['name'].gsub("\\", "")
			user['name']	= user['name'].gsub("'", %q(\\\'))  #SQL choking on /ᐠ｡ꞈ｡ᐟ\
			user['name']	= user['name'].gsub("’", "")
			user['name'] = @engine.escape(user['name'])

			user['klout_score'] = 'null' if user['klout_score'].nil?
			user['utc_offset'] = 'null' if user['utc_offset'].nil?
			user['time_zone'] =  @engine.escape(user['time_zone']) if !user['time_zone'].nil?
	
			user['region'] = 'null'
			user['sub_region'] = 'null'
			user['locality'] = 'null'
			user['country_code'] = 'null'
			user['geo_full_name'] = 'null'
			user['long'] = 'null'
			user['lat'] = 'null'
	
			if user['description'].nil?
				user['bio'] = 'null'
			else
				user['bio'] = user['description'].gsub("\\", "")
				user['bio'] = user['bio'].gsub("'", %q(\\\'))
				user['bio'] = user['bio'].gsub("’", "")
				user['bio'] = @engine.escape(user['bio'])
			end
	
			if user['location'].nil?
				user['location'] = 'null'
			else
				user['location']	= user['location'].gsub("'", %q(\\\'))
			end
	
			if !user['derived'].nil?
				if !user['derived']['locations'].nil?
					user['region'] = user['derived']['locations'][0]['region'].gsub("'", %q(\\\')) if !user['derived']['locations'][0]['region'].nil?
					user['sub_region'] = user['derived']['locations'][0]['sub_region'].gsub("'", %q(\\\')) if !user['derived']['locations'][0]['sub_region'].nil?
					user['locality'] = user['derived']['locations'][0]['locality'].gsub("'", %q(\\\')) if !user['derived']['locations'][0]['locality'].nil?
					user['country_code'] = user['derived']['locations'][0]['country_code']
					user['geo_full_name'] = user['derived']['locations'][0]['full_name'].gsub("'", %q(\\\'))
					user['long'] = user['derived']['locations'][0]['geo']['coordinates'][0]
					user['lat'] = user['derived']['locations'][0]['geo']['coordinates'][1]
				end
			end

		rescue Exception => e
			puts e.message
			puts e.backtrace.inspect
			puts 'stop'
		end
			
		return user
		
	end
	
	def transform_tweet_object(tweet)

		begin
			if tweet['truncated']
				message = tweet['extended_tweet']['full_text'].gsub("'", %q(\\\'))
				entities = tweet['extended_tweet']['entities']
				extended_entities = tweet['extended_tweet']['extended_entities']
				tweet['message'] = message
				tweet['entities'] = entities
				tweet['extended_entities'] = extended_entities
			else
				message = tweet['text']
				tweet['message'] = message.gsub("'", %q(\\\'))
			end
			
			tweet['source'] = @engine.escape(tweet['source'])

			#Handle display text start/end.
			if !tweet['display_text_range'].nil?
				tweet['display_text_start'] = tweet['display_text_range'][0]
				tweet['display_text_end'] = tweet['display_text_range'][1]
			else
				tweet['display_text_start'] = 'null'
				tweet['display_text_end'] = 'null'
			end

			#Handle Retweet details.
			if !tweet['retweeted_status'].nil?
				tweet['retweet_of'] = tweet['retweeted_status']['id']

				if tweet['retweeted_status']['truncated']
					tweet['retweeted_message'] = tweet['retweeted_status']['extended_tweet']['full_text'].gsub("'", %q(\\\'))
				else
					tweet['retweeted_message'] = tweet['retweeted_status']['text'].gsub("'", %q(\\\'))
				end
			else
				tweet['retweeted_message'] = ''
				tweet['retweet_of'] = 'null'
			end

			#Handle Quote Tweet details.
			if !tweet['quoted_status'].nil?
				tweet['quote_of'] = tweet['quoted_status']['id']
				if tweet['quoted_status']['truncated']
					tweet['quoted_message'] = tweet['quoted_status']['extended_tweet']['full_text'].gsub("'", %q(\\\'))
				else
					tweet['quoted_message'] = tweet['quoted_status']['text'].gsub("'", %q(\\\'))
				end
			else
				tweet['quoted_message'] = ''
				tweet['quote_of'] = 'null'
			end

			#Geo details - is there any geo metadata?.

			tweet['long'] = 'null'
			tweet['lat'] = 'null'
			tweet['lat_box'] = 'null'
			tweet['long_box'] = 'null'

			if !tweet['coordinates'].nil?
				tweet['long'] = tweet['coordinates']['coordinates'][0]
				tweet['lat'] = tweet['coordinates']['coordinates'][1]
				tweet['place_name'] = tweet['place']['full_name'].gsub("'", %q(\\\'))
				tweet['county_code'] = tweet['place']['country_code']

			elsif !tweet['place'].nil?
				tweet['long'] = tweet['place']['bounding_box']['coordinates'][0][0][0]
				tweet['lat'] = tweet['place']['bounding_box']['coordinates'][0][0][1]
				tweet['long_text'] = tweet['place']['bounding_box']['coordinates'][0][2][0]
				tweet['lat_box'] = tweet['place']['bounding_box']['coordinates'][0][2][1]
				tweet['place_name'] = tweet['place']['full_name'].gsub("'", %q(\\\'))
				tweet['country_code'] = tweet['place']['country_code']
			end

		rescue Exception => e
			puts e.message
			puts e.backtrace.inspect
			puts 'stop'
		end		

		return tweet
		
	end

	def store_tweets(results)
		
		tweets_array = []
		users_array = []
		links_array = []
		hashtags_array = []
		mentions_array = []
		symbols_array = []
		media_array = []
		
		#Iterate through Tweets and transform objects if needed.
		results.each do |tweet|
			#Transform Tweet object, collecting correct message/entities/extended_entities for extended Tweets, renaming some attributes.
			tweet = transform_tweet_object(tweet)
			tweets_array << tweet

			#Transform user object, renaming some attributes.
			user = transform_user_object(tweet['user'])
			users_array << user
			
			if tweet['entities']['urls'].length > 0
				links = transform_link_objects(tweet['entities']['urls'])
				link_data = {}
				link_data['tweet_id'] = tweet['id']
				link_data['links'] = links
				links_array << link_data 
			end

			if tweet['entities']['hashtags'].length > 0
				hashtag_data = {}
				hashtag_data['tweet_id'] = tweet['id']
				hashtag_data['hashtags'] = tweet['entities']['hashtags']
				hashtags_array << hashtag_data
			end

			if tweet['entities']['user_mentions'].length > 0
				mention_data = {}
				mention_data['tweet_id'] = tweet['id']
				mention_data['mentions'] = tweet['entities']['user_mentions']
				mentions_array << mention_data
			end

			if tweet['entities']['symbols'].length > 0 #
				symbol_data = {}
				symbol_data['tweet_id'] = tweet['id']
				symbol_data['symbols'] = tweet['entities']['symbols']
				symbols_array << symbol_data
			end

			if !tweet['extended_entities'].nil? #
				media_data = {}
				media_data['tweet_id'] = tweet['id']
				media_data['media'] = tweet['extended_entities']['media']
				media_array << media_data
			end

		end
		
		batch_write_tweets(tweets_array)
		batch_write_users(users_array)
		batch_write_links(links_array) if links_array.length > 0
		batch_write_hashtags(hashtags_array) if hashtags_array.length > 0
		batch_write_mentions(mentions_array) if mentions_array.length > 0
		batch_write_symbols(symbols_array) if symbols_array.length > 0
		batch_write_native_media(media_array) if media_array.length > 0

	end
	
	def disconnect
		#@engine.close or whatever the engine's disconnect command is.
		@engine = nil
		@connected = false
	end

	def connect
		begin
			@engine = Mysql2::Client.new(:host => @host, :port => @port, :username => @credentials['username'], :password => @credentials['password'], :database => @database )
			@connected = true # If error free.
		rescue
			@connected = false
		end
	end
	
end
