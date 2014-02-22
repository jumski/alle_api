
module AlleApi
  class CannotFindFidForConditionError < ArgumentError
    def initialize(category)
      @category = category
    end

    def message
      "Cannot find fid for category #{@category.name} " +
        "(id: #{@category.id}) - maybe not cached?"
    end
  end
end
