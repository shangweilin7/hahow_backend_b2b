# frozen_string_literal: true

module Types
  class CourseType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String, null: false
    field :lecturer, String, null: false
    field :description, String
    field :chapters, [ChapterType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def chapters
      dataloader.with(Sources::Association, :chapters).load(object).sort_by(&:position)
    end
  end
end
