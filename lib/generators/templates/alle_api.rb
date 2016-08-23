
AlleApi.config.tap do |config|
  # Used to render auction's description html.
  # You can use any object that responds to `call`,
  # it will be called with auction and auctionable as arguments
  config.description_renderer = lambda do |auction, auctionable|
    %Q{ Auction "#{auction.title}" of auctionable with id #{auctionable.id} }
  end

  # Event handlers, called when particular events in auction lifecycle occurs.
  # You can use any object that responds to `call` and accepts `auction` and `auctionable` arguments.
  #
  # config.auction_queued_for_publication_handler = lambda { |auction, auctionable| }
  # config.auction_queued_for_finishing_handler = lambda { |auction, auctionable| }
  # config.auction_buy_now_handler = lambda { |auction, auctionable| }
  # config.auction_published_handler = lambda { |auction, auctionable| }
  # config.auction_ended_handler = lambda { |auction, auctionable| }
end
