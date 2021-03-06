# AlleApi

Rails engine that integrates with Allegro WebAPI

For more info please visit [Allegro WebAPI documentation](http://allegro.pl/webapi/).

Engine is still under development. Please *don't use it in production!*

This project rocks and uses MIT-LICENSE.

## You need an API key in order to use this!

1. Login to Allegro
2. Navigate to [Generating API key](http://allegro.pl/myaccount/webapi.php/generateNewKey)
3. Use generated key in following instructions

## You need Redis!

Make sure your redis connection is available under `Redis.current`

## Ruby 1.9 only

Sorry folks, time to upgrade!

## Instalation

1. Install gem

    ```ruby
    # add to Gemfile
    gem 'alle_api', git: 'git://github.com/jumski/alle_api.git'
    ```

    ```bash
    # run in prompt
    $ bundle
    ```

2. Use generator to install required files:

    ```bash
    rails g alle_api:install
    ```

3. Fill in API credentials in `config/alle_api.yml`

4. Set up description renderer in `config/initializers/alle_api.rb`

5. Run migrations:

    ```bash
    rake db:migrate
    ```

6. Add `category_id` column to and include `AlleApi::Categorizable` module in models that you want to associate with Allegro category.

7. Include `AlleApi::Auctionable` module in models, that you want to be put on auctions.

8. Implement missing methods on your auctionables:

  - #title_for_auction: this will be used as an auction title
  - #category_id_for_auction: this will privide allegro category for auction

9. Run rake task to update API version key:

    ```bash
    rake alle_api:update_version_key
    ```

10. It should work now.

    - open console `rails c`
    - execute `AlleApi.api.get_journal`
    - it should return an array of last events

## TODO
- write documentation for implemented features
- write decent TODO :-)
