# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :courses, [CourseType], description: 'Returns data of all Courses', null: false
    field :course, CourseType, description: 'Returns a Course data by id', null: true do
      argument :id, Integer, required: true
    end

    def courses
      Course.all.order(created_at: :desc)
    end

    def course(id:)
      Course.find_by!(id:)
    end
  end
end
