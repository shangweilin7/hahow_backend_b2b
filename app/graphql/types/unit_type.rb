# frozen_string_literal: true

module Types
  class UnitType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String, null: false
    field :description, String
    field :content, String, null: false
    field :position, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
