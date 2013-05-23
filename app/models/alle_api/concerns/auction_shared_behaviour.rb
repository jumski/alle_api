# encoding: utf-8
module AlleApi
  module AuctionSharedBehaviour
    extend ActiveSupport::Concern

    included do
      belongs_to :auctionable, polymorphic: true
      belongs_to :account

      # validation
      numeric_fields =
        %w[ price
            economic_package_price
            priority_package_price
            economic_letter_price
            priority_letter_price ].map(&:to_sym)
      all_fields = numeric_fields + [:auctionable, :title]

      all_fields.each { |field| validates field, presence: true }
      numeric_fields.each { |field| validates field, numericality: true }

      validates :account, presence: true
      validates :additional_info, length: { maximum: 2000 }
      validate :maximum_of_30_chars_per_word_in_title, if: :title
      validate :ensure_title_length_with_special_chars

      def maximum_of_30_chars_per_word_in_title
        if title.scan(/\w{31,}/).any?
          errors.add(:title, "cannot contain words longer than 30 chars")
        end
      end

    end

    def ensure_title_length_with_special_chars
      if weighted_title_length > 50
        msg = "Maximum title length is 50 chars. "
        msg+= "Some characters counts as more than 1:"
        msg+= "'<' and '>' = 4 chars, '&' = 5 chars, '\"' = 6 chars)."
        errors.add(:title, msg)
      end
    end

    def weighted_title_length
      title.to_s.
            gsub(/[<>]/, 'x'*4).
            gsub(/&/,    'x'*5).
            gsub(/"/,    'x'*6).
            length
    end
  end
end
