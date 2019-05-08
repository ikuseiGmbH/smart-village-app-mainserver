# frozen_string_literal: true

module Types
  class LocationType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :department, String, null: true
    field :district, String, null: true
    field :region_id, String, null: true
    field :state, String, null: false
    field :coordinates, GeoLocationType, null: true

    def coordinates
      Location.geo_location
    end
  end
end
