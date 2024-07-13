FactoryBot.define do
  factory :chapter do
    name { :chapter_name }
    position { 0 }
    course
  end
end
