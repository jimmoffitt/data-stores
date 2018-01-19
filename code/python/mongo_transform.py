# This is your chance to drop unwanted Tweet JSON attributes by not including them here. 
# Here is where transformations, or remappings, happen. Changing attribute names? Storing 'user.description' as 'bio'? Do it here.
# Also, this code contains logic for correctly navigating the Tweet JSON, pulling the right attributes for extended Tweets. 
# Extended Tweets WILL have 'text', and possibly 'entities', attributes that are truncated and incomplete.  

def transform_tweet_json(tweet)

  #Handle extended Tweets.
  if tweet['truncated'] == false:
    message = tweet['text']
    entities = tweet['entities']
    extended_entities['extended_entities']
  else:
    message = tweet['extended_tweet']['full_text']
    entities = tweet['extended_tweet']['entities']
    extended_entities['extended_tweet']['extended_entities']
    
  if tweet['retweeted_status'] != None:
    retweeted_status_id = tweet['retweeted_status']['id']     
    
  if tweet['quoted_status'] != None:
    quoted_status_id = tweet['quoted_status']['id']     
    
  try:
    tweet_transform = {
      'tweet_id': tweet['id'],
      'message': message,
      'posted_at': tweet['created_at'],
      'truncated': tweet['truncated'],
      'display_text_range': tweet['display_text_range'],
      'source': tweet['source'],
      'lang': tweet['lang'],
      'entities': entities,
      'extended_entities': extended_entities,
      'retweet_of': retweeted_status_id,
      'quote_of': quoted_status_id,
      'quote_count': tweet['id'],
      'retweet_count': tweet['id'],
      'reply_count': tweet['id'],
      'favorited_count': tweet['id'],
      'retweeted': tweet['retweeted'],
      'favorited': tweet['favorited'],
      'place': tweet['place'],
      'coordinates': tweet['coordinates],
      'geo': tweet['geo'],
      'filter_level': tweet['filter_level'],
      'matching_rules': tweet['matching_rules'],
      
      #user attributes.
      'user_id': tweet['user']['id'],
      'name': tweet['user']['name'],
      'handle': tweet['user']['screen_name'],
      'posted_at': tweet['user']['created_at']
      'location': tweet['user']['location'],
      'followers_count': tweet['user']['followers_count'],
      'friends_count': tweet['user']['friends_count'],
      'listed_count': tweet['user']['listed_count'],
      'favorities_count': tweet['user']['favourites_count'],
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
      'geo_full_name': tweet['user']['locations'][0]['full_name'],  
      'long': tweet['user']['derived']['locations'][0]['geo']['coordinates'][0],
      'lat': tweet['user']['derived']['locations'][0]['geo']['coordinates'][1]
    }
    
  except KeyError, e:
    return False
   
  return tweet_transform
end



