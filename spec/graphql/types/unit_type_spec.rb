require 'rails_helper'

RSpec.describe Types::UnitType, type: :graphql do
  describe 'fields' do
    it 'Returns fields of course' do
      fields = described_class.fields.keys
      course = create(:course)
      chapter = create(:chapter, course:)
      unit = create(:unit, chapter:)
      query_string = <<-GQL
        query($id: Int!) {
          course(id: $id) {
            chapters {
              units {
                #{fields.join("\n")}
              }
            }
          }
        }
      GQL
      result = HahowBackendB2bSchema.execute(query_string, variables: { id: course.id })
      chapter_result = result['data']['course']['chapters'][0]['units'][0]
      expect(chapter_result)
        .to eq({ id: unit.id, name: unit.name, position: unit.position,
                 content: unit.content, description: unit.description,
                 createdAt: GraphQL::Types::ISO8601DateTime.coerce_result(unit.created_at, nil),
                 updatedAt: GraphQL::Types::ISO8601DateTime.coerce_result(unit.updated_at, nil) }.stringify_keys)
    end
  end
end
