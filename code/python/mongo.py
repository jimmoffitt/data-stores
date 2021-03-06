from pymongo import MongoClient
import json
from pprint import pprint

print "started"

client = MongoClient()

#Pick a style, any style
#client = MongoClient('localhost', 27017)
client = MongoClient('mongodb://localhost:27017')

#Connect to data store
#db = client.tweets
db = client['tweets']

#Specify collection
tweets_test = db.tweets_test

#Load up and iterate through some Tweets -- this file is a single response from Search API (~500 Tweets in "results" array)
tweet_data = json.load(open('./data/tweet_data.json'))
tweets = []
tweets = tweet_data['results']

for tweet in tweets:
    result = tweets_test.insert_one(tweet)
    
    
#Code for retrieving documents
tweet_of_interest = tweets.find_one({'user.handle': 'snowman'})
print(tweet_of_interest)

print "Quitting"
