from pymongo import MongoClient
import json
from pprint import pprint

print "started"


client = MongoClient()

#Pick a style, any style
#client = MongoClient('localhost', 27017)
client = MongoClient('mongodb://localhost:27017')

#Connect to data store
#db = client.tweets_test
db = client['tweets_test']

#Specify collection
tweets_test = db.tweets_test

#Load up and iterate through some Tweets -- this file is a single response from Search API (~500 Tweets in "results" array)
tweet_data = json.load(open('./data/tweet_data.json'))
tweets = []
tweets = tweet_data['results']

for tweet in tweets:
    result = tweets_test.insert_one(tweet)
    
print "Quitting"

