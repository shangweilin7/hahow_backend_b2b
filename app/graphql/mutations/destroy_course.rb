module Mutations
  class DestroyCourse < BaseMutation
    argument :id, Integer, required: true

    field :id, Integer, null: true

    def resolve(id:)
      course = Course.find(id)
      course.destroy!
      { id: }
    end
  end
end
