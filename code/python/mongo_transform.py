# This is your chance to drop unwanted Tweet JSON attributes by not including them here. 
# Here is where transformations, or remappings, happen. Changing attribute names? Do it here.
# Also, this code contains logic for correctly navigating the Tweet JSON, pulling the right attributes for extended Tweets. 
# Extended Tweets WILL have 'text', and possibly 'entities', attributes that are truncated and incomplete.  

def transform_tweet_json(tweet)

  #Handle extended Tweets.
  message = ''
  entities = {}
  

  try:
    tweet_transform = {
      'tweet_id': tweet['id'],
      'posted_at': tweet['created_at']
      'message': message,
      #user attributes.
      'name': tweet['user'][''],
      'handle': tweet['user'][''],
      'posted_at': tweet['user']['']
      'location': tweet['user']['location'],
      'followers_count': tweet['user']['followers_count'],
      'friends_count': tweet['user']['friends_count'],
      'listed_count': tweet['user']['listed_count'],
      'favourities_count': tweet['user']['favourites_count'],
      'statuses_count': tweet['user']['statuses_count'],
      'lang': tweet['user']['lang'],
      'time_zone': tweet['user']['time_zone'],
      'utc_offset': tweet['user']['utc_offset'],
      'bio': tweet['user']['description'],
      'url': tweet['user']['url'],
      'verified': tweet['user']['verified'],
      'protected': tweet['user']['protected'],
      'klout_score': tweet['user']['klout_score'],
      'country_code': tweet['user']['country_code'],
      'region': tweet['user']['region'],
      'sub_region': tweet['user']['sub_region'],
      'locality': tweet['user']['locality'],
       #TODO: complete these.
      'geo_full_name': tweet['user'][''],  
      'lat': tweet['user'][''],
      'long': tweet['user'][''],
      
      
      
      
      
      
    }
    
  except KeyError, e:
    return False
   
  return tweet_transform
end



