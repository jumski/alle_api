
module AlleApi
  module SoftRemovable
    extend ActiveSupport::Concern

    def soft_removed?
      soft_removed_at.present?
    end

    def soft_remove!
      self.soft_removed_at = DateTime.now
      self.save
    end

    included do
      def self.present
        where(soft_removed_at: nil)
      end

      def self.soft_removed
        where('soft_removed_at IS NOT NULL')
      end
    end

  end
end
