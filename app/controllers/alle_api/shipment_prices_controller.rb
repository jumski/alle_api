module AlleApi
  class ShipmentPricesController < ApplicationController
    before_filter :ensure_valid_weight, only: [:index]

    def index
      render json: ShipmentPrice.all_for_weight(params[:weight])
    end

    private
      def ensure_valid_weight
        weight = params[:weight].to_i

        if weight <= 0
          render json: false, status: :unprocessable_entity
          return false
        end
      end
  end
end
