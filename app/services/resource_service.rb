# frozen_string_literal: true

class ResourceService
  attr_accessor :data_provider
  attr_accessor :resource
  attr_accessor :resource_class

  def initialize(data_provider:)
    @data_provider = data_provider
  end

  def create(resource_class, params)
    @params = params

    # cleanup params for given :id
    @old_resource_id = @params.delete(:id)

    # Wenn die Rolle Restricted eine Information anlegt,
    # so ist diese per default nicht sichtbar, es sei denn
    # das Attribute 'visible' wird in den params mitgegeben und ist 'true'
    if @data_provider.user.restricted_role? && resource_class.respond_to?(:visible)
      @params = { visible: false }.merge(@params)
    end

    @resource_class = resource_class
    @resource = resource_class.new(@params)
    @resource.data_provider = @data_provider

    # skip create if record already exists and new record has the same attribute values as the new
    # record and the record is not marked as 'always_recreate'
    @external_resource = find_external_resource
    @old_resource = find_old_resource
    if @external_resource.present? && unchanged_attributes? && !always_recreate?
      @external_resource.touch
      return @old_resource
    end

    resource_or_error_message(update_or_create)
  end

  private

    # Find old resource
    #
    # @return [Object] Instance of @resource_class
    def find_old_resource
      if @old_resource_id.present?
        @resource_class.filtered_for_current_user(@data_provider.user).find_by(id: @old_resource_id)
      else
        @external_resource.try(:external)
      end
    end

    def update_or_create
      if @old_resource.present?
        update_resource
      else
        create_new_resource
      end
    end

    def update_resource
      # find all association names to delete for a resource
      association_names_to_delete = @resource_class
                                      .reflect_on_all_associations
                                      .select { |a| a.options[:dependent] == :destroy }.map(&:name)

      # delete all nested resources
      association_names_to_delete.each do |association_name|
        associations = @old_resource.send(association_name)
        associations.destroy_all if !singular?(association_name) && associations.any?
        associations.destroy if singular?(association_name) && associations.present?
      end

      # update all attributes and recreate nested resources
      @old_resource.update(@params)

      ExternalReference.create(
        data_provider: @old_resource.data_provider,
        external_id: @old_resource.id,
        external_type: @resource_class,
        unique_id: @old_resource.unique_id
      )

      set_default_categories if @old_resource.respond_to?(:categories)

      @old_resource
    end

    def create_new_resource
      ActiveRecord::Base.transaction do
        @external_resource.destroy if @external_resource.present?
        if @resource.save
          create_external_resource
          set_default_categories if @resource.respond_to?(:categories)
        end

        @resource
      end
    end

    def unchanged_attributes?
      return false if @old_resource.blank?
      return @resource.compareable_attributes == @old_resource.compareable_attributes if @old_resource.respond_to?(:compareable_attributes)

      # Fallback, wenn :compareable_attributes nicht beim Model definiert ist.
      except_attributes = ["id", "created_at", "updated_at", "tag_list", "category_id", "region_id"]
      @resource.attributes.except(*except_attributes) == @old_resource.attributes.except(*except_attributes)
    end

    def always_recreate?
      return false if @data_provider.blank?

      class_name = @resource_class.name
      setting = @data_provider.data_resource_settings.where(data_resource_type: class_name).first
      return false if setting.blank?

      setting.always_recreate_on_import == "true"
    end

    def find_external_resource
      return nil if @params.fetch(:force_create, false)

      ExternalReference.find_by(
        data_provider: @data_provider,
        external_type: @resource_class,
        unique_id: @resource.unique_id
      )
    end

    def create_external_resource
      ExternalReference.create(
        data_provider: @data_provider,
        external_id: @resource.id,
        external_type: @resource_class,
        unique_id: @resource.unique_id
      )
    end

    def resource_or_error_message(record)
      if record.valid?
        record
      else
        GraphQL::ExecutionError.new("Invalid input: #{record.errors.full_messages.join(", ")}")
      end
    end

    def set_default_categories
      setting = @data_provider.data_resource_settings.where(data_resource_type: @resource_class.name).first
      return if setting.blank?
      return if setting.default_category_ids.blank?

      categories_to_add = setting.default_category_ids.compact.uniq.delete_if(&:blank?)
      return if categories_to_add.blank?

      categories_to_add.each do |cat_id|
        category = Category.find_by(id: cat_id)
        @resource.categories << category unless @resource.category_ids.include?(cat_id.to_i)
      end
    end

    def singular?(some_object)
      some_string = some_object.to_s

      some_string.singularize == some_string
    end
end
