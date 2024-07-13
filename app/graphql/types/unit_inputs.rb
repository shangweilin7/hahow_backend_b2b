module Types
  class UnitInputs < Types::BaseInputObject
    argument :id, Integer, required: false
    argument :chapter_id, Integer, required: false
    argument :name, String, required: false
    argument :description, String, required: false
    argument :content, String, required: false
    argument :position, Integer, required: false
    argument :_destroy, Boolean, required: false
  end
end
