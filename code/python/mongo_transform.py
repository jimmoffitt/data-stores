# This is your chance to drop unwanted Tweet JSON attributes by not including them here.
# Here is where transformations, or remappings, happen. Changing attribute names? Storing 'user.description' as 'bio'? Do it here.
# Also, this code contains logic for correctly navigating the Tweet JSON, pulling the right attributes for extended Tweets.
# Extended Tweets WILL have 'text', and possibly 'entities', attributes that are truncated and incomplete.
import json

class TweetTransform:

    #Tweet arriving as JSON, transformed content returned as JSON.
    def transform_tweet_json(self, tweet):
        
        tweet = json.loads(tweet) #Load Tweet JSON into a dictionary/hash.

        #Handle extended Tweets.
        if tweet['truncated'] == False:
            message = tweet['text']
            entities = tweet['entities']
            extended_entities = tweet['extended_entities']
        else:
            message = tweet['extended_tweet']['full_text']
            entities = tweet['extended_tweet']['entities']
            extended_entities = tweet['extended_tweet']['extended_entities']

        if tweet['retweeted_status'] != None:
            retweeted_status_id = tweet['retweeted_status']['id']

        if tweet['quoted_status'] != None:
            quoted_status_id = tweet['quoted_status']['id']

        try:
            
            user_transform = {
                #user attributes.
                'user_id': tweet['user']['id'],
                'name': tweet['user']['name'],
                'handle': tweet['user']['screen_name'],
                'posted_at': tweet['user']['created_at'],
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
                'derived': tweet['user']['derived']
            }
            
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
                'quote_count': tweet['quote_count'],
                'retweet_count': tweet['retweet_count'],
                'reply_count': tweet['reply_count'],
                'favorited_count': tweet['favorited_count'],
                'retweeted': tweet['retweeted'],
                'favorited': tweet['favorited'],
                'place': tweet['place'],
                'coordinates': tweet['coordinates'],
                'geo': tweet['geo'],
                'filter_level': tweet['filter_level'],
                'matching_rules': tweet['matching_rules'],
                'user': user_transform
            }

        except:
                return False

        return json.dumps(tweet_transform) #Returning as JSON.
