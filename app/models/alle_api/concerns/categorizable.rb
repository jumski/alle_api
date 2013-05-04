
module AlleApi
  module Categorizable
    extend ActiveSupport::Concern

    included do
      belongs_to :category, class_name: 'AlleApi::Category'
      attr_accessible :category, :category_id

      validates :category, presence: true
      validate :allows_only_category_that_is_leaf_node

      delegate :name,
        to: :category, prefix: true, allow_nil: true
    end

    def allows_only_category_that_is_leaf_node
      if category
        errors.add(:category, "should be leaf node") unless category.leaf_node?
      end
    end
  end
end
