### The Pivot
![Codeship](https://codeship.com/projects/f01d6570-683e-0132-d0c9-3ad5c353d440/status?branch=master)

Started from the bottom: [Crossroads Lodge](https://crossroads-lodge.herokuapp.com/)  
Now we're here: [TravelHome](http://travel-home.herokuapp.com/)

**Created By**:
* [Alex](https://github.com/dalexj)
* [Viki](https://github.com/VikiAnn)
* [Sam](https://github.com/skuhlmann)
* [Danny](https://github.com/dglunz)

Be sure you run `$ brew install imagemagick`

#### Our Mascots
<img src="http://i.imgur.com/VeOaXu0.jpg" width="200"> <img src="http://i.imgur.com/43OQPVM.jpg" width="200">

### Project Dependencies

* Mandrill -- required for transactional emails -- needs `MANDRILL_USERNAME` and `MANDRILL_APIKEY` ENV vars
* Amazon S3 -- used for file uploads -- needs `S3_BUCKET_NAME`, `AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY` ENV vars

You'll also need to make sure Paperclip is configured in production to use
the appropriate region for the S3 Bucket you provided. This setting is found
in `config/environments/production.rb`:

```
  config.paperclip_defaults = {
    storage: :s3,
    s3_host_name: 's3.amazonaws.com', # <-- SET THIS TO YOUR REGION
    s3_credentials: {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    bucket: ENV['S3_BUCKET_NAME']
  }
```

Finally, if you created a dedicated AWS "IAM" user account for this application's
S3 access, don't forget to set up an "Access Policy" for that user, giving them
"Full Access" to AWS S3 resources. More info on this step can be found [here](http://rexstjohn.com/how-to-solve-access-denied-with-heroku-paperclip-s3-ror/).