# frozen_string_literal: true

module Types
  class ChapterType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String, null: false
    field :position, Integer, null: false
    field :units, [UnitType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def units
      dataloader.with(Sources::Association, :units).load(object).sort_by(&:position)
    end
  end
end
