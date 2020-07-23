module Spree
    module Api
      module V2
        module Storefront
          class ReviewsController < ::Spree::Api::V2::BaseController
            include Spree::Api::V2::CollectionOptionsHelpers
            # before_action :require_spree_current_user
            before_action :load_product, only: [:create, :destroy]

            def index
              render_serialized_payload { serialize_collection(paginated_collection) }
            end

            def create
              params[:review][:rating].sub!(/\s*[^0-9]*\z/, '') unless params[:review][:rating].blank?

              @review = Spree::Review.new(review_params)
              @review.product = @product
              @review.user = spree_current_user if spree_user_signed_in?
              @review.ip_address = request.remote_ip
              @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]

              authorize! :create, @review
              @review.save!
              render_serialized_payload(201) { serialize_order(order) }
            end
  
            def show
              render_serialized_payload { serialize_resource(resource) }
            end
            
            private

            def sorted_collection
              collection_sorter.new(collection, params).call
            end

            def collection_sorter
              Spree::Api::Dependencies.storefront_order_sorter.constantize
            end

            def load_product
              @product = Spree::Product.friendly.find(params[:product_id])
            end

            def permitted_review_attributes
              [:rating, :title, :review, :name, :show_identifier]
            end
          
            def review_params
              params.require(:review).permit(permitted_review_attributes)
            end
          end
        end
      end
    end
  end
  