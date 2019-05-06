class EventRecord < ApplicationRecord
  belongs_to :category
  has_many :urls, as: :web_urlable, class_name: "WebUrl"
  has_one :data_provider, as: :provideable
  has_one :organizer, as: :companyable, class_name: "OperatingCompany"
  has_many :adresses, as: :adressable
  has_one :location, as: :locateable
  has_many :contacts, as: :contactable
  has_one :accessibilty_information, as: :accessable
  has_many :price_informations, as: :priceable, class_name: "Price"
  has_many :media_contents, as: :mediaable
  has_one :repeat_duration
  has_one :highlight, as: :highlightable
  has_many :dates, as: :dateable, class_name: "FixedDate"
  validates_presence_of :title
end
