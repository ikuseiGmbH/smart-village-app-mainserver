# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tour, type: :model do
  it { is_expected.to have_many(:geometry_tour_data) }
  it { is_expected.to define_enum_for(:means_of_transportation) }
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  external_id             :integer
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
