class DummyAuctionable < ActiveRecord::Base
  include AlleApi::Auctionable

  attr_accessible :category_id, :title, :weight

  def title_for_auction
    "#{title} for auction"
  end

  def category_id_for_auction
    666
  end

  def image_1_contents
    File.read(Rails.root.join 'spec/support/fixtures/1x1.jpg')
  end
end
