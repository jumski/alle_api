$: << File.expand_path(File.dirname(__FILE__))

require 'savon'
require 'virtus'
require 'redis/namespace'
require 'redis/objects'
require 'hashie'
require 'ancestry'
require 'workflow'
require 'sidekiq'

require 'rails'
require 'pry' if Rails.env.development?

require 'alle_api/engine'

require 'alle_api/config'
require 'alle_api/client'
require 'alle_api/api'

require 'alle_api/invalid_auction_for_publication_error'
require 'alle_api/invalid_auction_for_finishing_error'
require 'alle_api/provide_own_implementation_error'
require 'alle_api/cannot_find_find_for_condition_error'
require 'alle_api/cannot_trigger_event_on_invalid_auction_error'

require 'alle_api/type/auction'

require 'alle_api/wrapper/base'
require 'alle_api/wrapper/event'
require 'alle_api/wrapper/deal_event'
require 'alle_api/wrapper/field'

require_relative '../app/models/alle_api/concerns/auction_shared_behaviour'
require_relative '../app/models/alle_api/concerns/auction_state_machine'
require_relative '../app/models/alle_api/concerns/auctionable'
require_relative '../app/models/alle_api/concerns/categorizable'
require_relative '../app/models/alle_api/concerns/account_owner'
require 'alle_api/soft_removable'

require 'alle_api/helper/components_updater'
require 'alle_api/helper/base_synchronizer'
require 'alle_api/helper/fields_synchronizer'
require 'alle_api/helper/category_tree_synchronizer'
require 'alle_api/helper/versions'

require 'alle_api/action/base'
require 'alle_api/action/validation_error'
require 'alle_api/action/authenticate'
require 'alle_api/action/create_auction'
require 'alle_api/action/finish_auctions'
require 'alle_api/action/get_categories'
require 'alle_api/action/get_journal'
require 'alle_api/action/get_deals_journal'
require 'alle_api/action/get_fields'
require 'alle_api/action/get_fields_for_category'
require 'alle_api/action/get_versions'

require 'alle_api/job/base'
require 'alle_api/job/authenticate'
require 'alle_api/job/error_job'
require 'alle_api/job/update_components'
require 'alle_api/job/update_categories_tree'
require 'alle_api/job/update_fields'
require 'alle_api/job/fetch_auction_events'
require 'alle_api/job/trigger_auction_events'
require 'alle_api/job/publish_auction'
require 'alle_api/job/finish_auction'

module AlleApi
  module_function

  def redis
    @redis ||= Redis::Namespace.new('AlleApi', redis: Redis.current)
  end

  def config
    AlleApi::Config[Rails.env]
  end

  def utility_api
    Account.utility.api
  end

  def versions
    Helper::Versions.new
  end

  def root
    File.expand_path(File.dirname(File.dirname(__FILE__)))
  end

  def models_dir
    "#{root}/app/models/alle_api"
  end

  def controllers_dir
    "#{root}/app/controllers/alle_api"
  end

end
