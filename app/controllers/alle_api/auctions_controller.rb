module AlleApi
  class AuctionsController < ApplicationController
    def preview
      unless @auction = Auction.find_by_id(params[:id])
        redirect_to(root_path)
        return
      end

      @renderer = AlleApi.config.description_renderer
      @auctionable = @auction.auctionable

      render layout: nil, template: 'layouts/alle_api/allegro'
    end
  end
end
