# frozen_string_literal: true

FactoryBot.define do
  factory :news_item do
    author { "MyString" }
    news_type { "" }
    full_version { true }
    characters_to_be_shown { 0 }
    publication_date { "2019-05-02 12:50:44" }
    published_at { "2019-05-02 12:50:44" }
    show_publish_date { false }
  end
end

# == Schema Information
#
# Table name: news_items
#
#  id                     :bigint           not null, primary key
#  author                 :string(255)
#  type                   :string(255)
#  full_version           :boolean
#  characters_to_be_shown :integer
#  publication_date       :datetime
#  published_at           :datetime
#  show_publish_date      :boolean
#  news_type              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
