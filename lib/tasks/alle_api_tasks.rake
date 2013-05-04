# desc "Explaining what the task does"
# task :alle_api do
#   # Task goes here
# end

require 'progressbar'

namespace :alle_api do
  task :update_version_key => [:environment] do
    AlleApi.client.update_version_key
  end

  task :update_categories_fids => [:environment] do
    require Rails.root.join 'lib/save_condition_fid_to_categories'
    AlleApi.condition_fid_importer
  end

  task :update_path_texts => [:environment] do
    require Rails.root.join 'vendor/alleapi/lib/alleapi'
    pbar = ProgressBar.new('path_text', AlleApi::Category.books_subtree.count)

    AlleApi::Category.books_subtree.find_each do |category|
      category.update_attribute :path_text, category.path.map(&:name).join(' > ')
      pbar.inc
    end

    pbar.finish
  end
end
