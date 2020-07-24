# frozen_string_literal: true

class DataProvider < ApplicationRecord
  store :roles, accessors: %i[role_point_of_interest role_tour role_news_item role_event_record], coder: JSON

  has_many :data_resource_settings, class_name: "DataResourceSetting"
  has_one :user
  has_one :address, as: :addressable
  has_one :contact, as: :contactable
  has_one :logo, as: :web_urlable, class_name: "WebUrl"

  before_save :parse_role_values

  accepts_nested_attributes_for :address, :contact, :logo, :data_resource_settings

  def parse_role_values
    roles.each do |key, value|
      roles[key] = value == "true" || value == true
    end
  end
end

# == Schema Information
#
# Table name: data_providers
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  description     :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  always_recreate :text(65535)
#  roles           :text(65535)
#
