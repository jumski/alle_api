class AlleApi::Category < ActiveRecord::Base
  include ::AlleApi::SoftRemovable

  has_ancestry cache_depth: true, orphan_strategy: :restrict

  validates :name, presence: true
  attr_accessible :name, :position, :parent_id

  has_many :fields, class_name: "AlleApi::Field"
  belongs_to :condition_field, class_name: 'AlleApi::Field'

  class << self
    def create_from_allegro(attributes)
      id = attributes.delete :id
      parent_id = attributes.delete :parent_id

      category = new(attributes)
      category.id = id
      category.allegro_parent_id = parent_id
      category.save!
      category
    end

    def assign_proper_parents!
      transaction do
        base = present.
          where('allegro_parent_id IS NOT NULL').
          where('allegro_parent_id > 0').
          order('allegro_parent_id ASC')

        base.find_each do |category|
          category.parent_id = category.allegro_parent_id
          category.allegro_parent_id = nil
          category.save!
        end

        AlleApi::Category.check_ancestry_integrity!
      end
    end

    def suggestions_for(term)
      categories = where("#{table_name}.name like ?", "%#{term}%")
      categories.map do |category|
        hash = category.attributes
        hash[:label] = category.path_text
        hash[:value] = category.name
        hash
      end
    end

    def without_root_nodes
      from_depth(1)
    end

    def leaf_nodes
      where("#{table_name}.leaf_node = ?", true)
    end

    def books_subtree
      descendants_of 7
    end

    def suggestions_for_books(term)
      leaf_nodes.present.with_condition_field.suggestions_for(term)
    end

    def with_condition_field
      joins(:condition_field)
    end

    def update_leaf_nodes!
      transaction do
        present.find_each do |category|
          category.leaf_node = category.is_childless?
          category.save!
        end
      end
    end

    def update_path_texts!
      transaction do
        present.leaf_nodes.find_each do |category|
          path_text = category.path.pluck(:name).join(' > ')
          category.path_text = path_text
          category.save!
        end
      end
    end

    def cache_condition_field!
      transaction do
        ids = joins(:fields).merge(AlleApi::Field.condition_fields).pluck("#{table_name}.id")

        where(id: ids).includes(:fields).find_each do |parent|
          condition_field = parent.fields.find(&:condition_field?)

          parent.update_attribute :condition_field_id, condition_field.id
          parent.children.update_all condition_field_id: condition_field.id
        end
      end
    end
  end

  def fid_for_condition
    if condition_field_id.blank?
      raise ::AlleApi::CannotFindFidForConditionError, self
    end

    condition_field_id
  end
end
