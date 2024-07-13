module Mutations
  class CreateCourse < BaseMutation
    argument :attributes, Types::CourseInputs, required: true

    field :course, Types::CourseType, null: true

    def resolve(attributes:)
      course = Course.new(attributes.to_h)
      course.save!
      { course: }
    end
  end
end
