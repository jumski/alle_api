
AlleApi.config.tap do |config|
  # = Description renderer
  # you can use any object that responds to `call`
  # it will be called with auction and auctionable as arguments
  # it's return value will be used as an auction description when published
  config.description_renderer = lambda do |auction, auctionable|
    %Q{ Auction "#{auction.title}" of auctionable with id #{auctionable.id} }
  end
end
