### Home Away

HomeAway provides a peer-to-peer marketplace for finding short-term
rentals around the world.

[Visit Us Online](https://home-away.herokuapp.com/)

[Skylight Monitoring](https://www.skylight.io/app/applications/sCCS6fz7N9o)

### Project Dependencies

* Mandrill -- required for transactional emails -- needs `MANDRILL_USERNAME` and `MANDRILL_APIKEY` ENV vars
* Amazon S3 -- used for file uploads -- needs `S3_BUCKET_NAME`, `AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY` ENV vars
* Skylight IO -- used for production performance monitoring -- Configure this by setting a `SKYLIGHT_AUTHENTICATION` environment variable
* ImageMagick -- used for resizing and cropping images in development; make sure you have it installed: `brew install imagemagick`

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

### Heroku and Skylight.io

This application is already deployed to [heroku](https://home-away.herokuapp.com/) and configured with [Skylight.io](https://www.skylight.io/app/applications/sCCS6fz7N9o-/1432128600/6h/endpoints) for performance monitoring.
You will be added to the appropriate projects when you join the team.

### Testing

This project uses RSpec for its test suite. Run the tests with `rake`, `rake spec`, or `rspec`.

**Contributor Log:**:
* [Alex](https://github.com/dalexj)
* [Viki](https://github.com/VikiAnn)
* [Sam](https://github.com/skuhlmann)
* [Danny](https://github.com/dglunz)

Started from the bottom: [Crossroads Lodge](https://crossroads-lodge.herokuapp.com/)
Now we're here: [HomeAway](http://home-away.herokuapp.com/)