# frozen_string_literal: true

#
# A Tour is a planned route to walk ride or canoe and which passes through
# the surrounding areas of the Smart Village
#
class Tour < Attraction
  has_many :geometry_tour_data, as: :geo_locateable, class_name: "GeoLocation"
  enum means_of_transportation: { bike: 0, canoe: 1, foot: 2 }

  has_one :location, as: :locateable

  scope :filtered_for_current_user, ->(current_user) do
    return all if current_user.admin_role?

    where(data_provider_id: current_user.data_provider_id)
  end

  accepts_nested_attributes_for :geometry_tour_data, :location

  def unique_id
    fields = [name, type]

    first_address = addresses.first
    address_keys = %i[street zip city kind]
    address_fields = address_keys.map { |a| first_address.try(:send, a) }

    generate_checksum(fields + address_fields)
  end
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  name                    :string(255)
#  description             :text(65535)
#  mobile_description      :string(255)
#  active                  :boolean          default(TRUE)
#  length_km               :integer
#  means_of_transportation :integer
#  category_id             :bigint
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#  data_provider_id        :integer
#
