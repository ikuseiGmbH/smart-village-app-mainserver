# frozen_string_literal: true

module Types
  class InputTypes::GenericItemInput < BaseInputObject
    argument :push_notification, Boolean, required: false
    argument :author, String, required: false
    argument :title, String, required: false
    argument :generic_type, String, required: false
    argument :external_id, String, required: false
    argument :publication_date, String, required: false
    argument :published_at, String, required: false
    argument :category_name, String, required: false
    argument :payload, GraphQL::Types::JSON, required: false
    argument :generic_items, [Types::InputTypes::GenericItemInput], required: false,
                                                                    as: :generic_items_attributes,
                                                                    prepare: lambda { |generic_items, _ctx|
                                                                      generic_items.map(&:to_h)
                                                                    }
    argument :companies, [Types::InputTypes::OperatingCompanyInput], required: false,
                                                                     as: :companies_attributes,
                                                                     prepare: lambda { |companies, _ctx|
                                                                       companies.map(&:to_h)
                                                                     }

    argument :categories, [Types::InputTypes::CategoryInput], required: false,
                                                              as: :category_names,
                                                              prepare: lambda { |category, _ctx|
                                                                category.map(&:to_h)
                                                              }
    argument :web_urls, [Types::InputTypes::WebUrlInput], required: false,
                                                          as: :web_urls_attributes,
                                                          prepare: ->(source_url, _ctx) { source_url.map(&:to_h) }
    argument :addresses, [Types::InputTypes::AddressInput], required: false,
                                                            as: :address_attributes,
                                                            prepare: lambda { |address, _ctx|
                                                              address.to_h
                                                            }
    argument :content_blocks, [Types::InputTypes::ContentBlockInput], required: false,
                                                                      as: :content_blocks_attributes,
                                                                      prepare: lambda { |content_blocks, _ctx|
                                                                        content_blocks.map(&:to_h)
                                                                      }

  end
end