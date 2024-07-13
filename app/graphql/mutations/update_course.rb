module Mutations
  class UpdateCourse < BaseMutation
    argument :id, Integer, required: true
    argument :attributes, Types::CourseInputs, required: false

    field :course, Types::CourseType, null: true

    def resolve(id:, attributes:)
      course = Course.find(id)
      course.update!(attributes.to_h)
      { course: }
    end
  end
end
