module Types
  class ChapterInputs < Types::BaseInputObject
    argument :id, Integer, required: false
    argument :course_id, Integer, required: false
    argument :name, String, required: false
    argument :position, Integer, required: false
    argument :_destroy, Boolean, required: false
    argument :units_attributes, [UnitInputs], required: false
  end
end
