from pymongo import MongoClient
import json
from pprint import pprint

print "started"

#Create a MongoDB connection... Mongo service instance must be running. (>>>sudo mongod)
client = MongoClient()
#client = MongoClient('localhost', 27017) #Pick a style, any style
client = MongoClient('mongodb://localhost:27017')

#Specify a data store, creating it if it does not exist. 
#db = client.tweets #Pick a style, any style
db = client['tweets']

#Connect to JSON document collection, creating it if it does not exist. 
tweets_test = db.tweets_test

#Load up and iterate through some Tweets -- this file is a single response from Search API (~500 Tweets in "results" array)
tweet_data = json.load(open('./data/tweet_data.json'))
tweets = []
tweets = tweet_data['results']

for tweet in tweets:
    result = tweets_test.insert_one(tweet)

print "Quitting"
