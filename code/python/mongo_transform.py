#OK, this is your chance to drop unwanted Tweet JSON attributes by not including them here. 


def transform_tweet_json(tweet)

  try:
    tweet_transform = {
      'tweet_id': tweet['id'].split(':')[2],
      'message': text,
      'screen_name': tweet['actor']['preferredUsername'],
      'posted_at': parse(tweet['created_at'])
    }
    
  except KeyError, e:
    return False
   
  return tweet_transform
end



