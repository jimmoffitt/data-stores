import mysql.connector

cnx = mysql.connector.connect(user='me', database='tweets')
cursor = cnx.cursor()

#Make up a Tweet
tweet_data = {
  'id': "948668540944551943",
  'posted_at': "Wed Jan 03 21:33:00 +0000 2018",
  'message': 'More of these please... https://t.co/AnX5dkiBsA',
  'user_id': "906948460078698496"
}


add_tweet = ("INSERT INTO tweets "
               "(id, posted_at, message, user_id) "
               "VALUES (%s, %s, %s, %s)")

# Insert Tweet
cursor.execute(add_tweet, tweet_data)

# Make sure data is committed to the database
cnx.commit()

cursor.close()
cnx.close()
