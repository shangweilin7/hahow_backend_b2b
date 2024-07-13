module Types
  class CourseInputs < Types::BaseInputObject
    argument :name, String, required: false
    argument :lecturer, String, required: false
    argument :description, String, required: false
    argument :chapters_attributes, [ChapterInputs], required: false
  end
end
