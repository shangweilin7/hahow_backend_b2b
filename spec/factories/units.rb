FactoryBot.define do
  factory :unit do
    name { :unit_name }
    description { :description }
    content { :content }
    position { 0 }
    chapter
  end
end
