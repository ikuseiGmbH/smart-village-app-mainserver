# frozen_string_literal: true

module Types
  class MediaContentType < Types::BaseObject
    field :id, ID, null: true
    field :caption_text, String, null: true
    field :copyright, String, null: true
    field :height, AnyPrimitiveType, null: true
    field :width, AnyPrimitiveType, null: true
    field :content_type, String, null: true
    field :source_url, WebUrlType, null: true
  end
end
