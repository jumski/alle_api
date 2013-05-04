module AlleApi
  class CategoriesController < ApplicationController
    def index
      respond_to do |format|
        format.json do
          render json: Category.suggestions_for_books(params[:term])
        end
      end
    end
  end
end
