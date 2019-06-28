# frozen_string_literal: true

module Types
  class GeoLocationType < Types::BaseObject
    field :id, ID, null: false
    field :latitude, AnyPrimitiveType, null: false
    field :longitude, AnyPrimitiveType, null: false
  end
end
