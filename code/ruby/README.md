

Simple query:

```ruby
def get_tweets_count(params)

  sSQL = "SELECT COUNT(*)
          FROM tweets
          WHERE `posted_at` > '#{params[:start_date]}'
            AND `posted_at` <= '#{params[:end_date]}';"
end
```

More complex query:

```ruby
#Handles both hashtag arrays and single hashtags.
def get_tweets_with_hashtag(params, hashtag)

   if hashtag.include?('|') then
      tags = hashtag.split('|')

      hashtag_list = tags.map {|str| "'#{str}'"}.join(',')
      hashtag_match = " IN (#{hashtag_list}) "

   elsif hashtag[0,1] == '*' then
      hashtag_match = " LIKE '%#{hashtag[1,hashtag.length]}' "
   else
      hashtag_match = " = '#{hashtag}' "
   end

   sSQL = "SELECT t.`posted_at`
            FROM tweets t, hashtags h
            WHERE h.hashtag " + hashtag_match +
             "AND t.tweet_id = h.tweet_id
              AND t.`posted_at` > '#{params[:start_date]}'
              AND t.`posted_at` <= '#{params[:end_date]}'
            ORDER BY t.`posted_at` ASC;"
end
```
