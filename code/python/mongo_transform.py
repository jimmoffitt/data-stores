#OK, this is your chance to drop unwanted Tweet JSON attributes by not including them here. 


def process_tweet(tweet):



 #pre-processing 
 #Sort out which Tweet message and entities attributes to grab (depends on whether this is an extended Tweet or legacy size)

 text = ""
 entities = {}

  
  objects = {}
  
  try:
    tweet_object = {
      'tweet_id': tweet['id'].split(':')[2],
      'text': text,
      'screen_name': tweet['actor']['preferredUsername'],
      'posted_at': parse(tweet['created_at']),
      'gnip_rules': tweet['gnip']['matching_rules']
    }
    
    objects['tweet'] = tweet_object
    
    user_object = {
      'user_id': tweet['user']['id']   #Or use 'id_str'?
      
    }
    
    objects['user'] = user_object
    
    

    return objects

  except KeyError, e:
    return False
