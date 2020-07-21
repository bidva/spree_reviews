module Spree
    module Api
      module V2
        module Storefront
          class ReviewsController < ::Spree::Api::V2::BaseController
            before_action :require_spree_current_user
  
            def show
              render json: {data: 'test'}
            end
          end
        end
      end
    end
  end
  