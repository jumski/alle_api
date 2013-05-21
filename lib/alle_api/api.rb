
module AlleApi
  class Api
    attr_reader :client

    def initialize(config)
      @client = Client.new(config)
    end

    def authenticate
      Action::Authenticate.new(client).do
    end

    def create_auction(auction)
      Action::CreateAuction.new(client).do(auction)
    end

    def get_categories
      Action::GetCategories.new(client).do
    end

    def get_journal(starting_point = nil)
      Action::GetJournal.new(client).do(starting_point)
    end

    def get_deals_journal(starting_point = nil)
      Action::GetDealsJournal.new(client).do(starting_point)
    end

    def get_transactions(ids)
      Action::GetTransactions.new(client).do(ids)
    end

    def get_fields
      Action::GetFields.new(client).do
    end

    def get_fields_for_category(category_id)
      Action::GetFieldsForCategory.new(client).do(category_id)
    end

    def get_versions
      Action::GetVersions.new(client).do
    end

    def finish_auctions(remote_ids)
      Action::FinishAuctions.new(client).do(remote_ids)
    end

    def get_incoming_payments(params = {})
      Action::GetIncomingPayments.new(client).do(params)
    end

    def finish_auction(remote_id)
      result = finish_auctions([remote_id])

      result[:finished].include? remote_id
    end
  end
end
