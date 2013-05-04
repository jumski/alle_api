
AlleApi.config[:description_renderer] = lambda do |auction, auctionable|
  "#{auction.id} -> #{auction.title} -> #{auction.price}"
end
