require 'rails_helper'

RSpec.describe Types::ChapterType, type: :graphql do
  describe 'fields' do
    it 'Returns fields of course' do
      fields = described_class.fields.keys - ['units']
      course = create(:course)
      chapter = create(:chapter, course:)
      unit = create(:unit, chapter:)
      query_string = <<-GQL
        query($id: Int!) {
          course(id: $id) {
            chapters {
              #{fields.join("\n")}
              units {
                id
              }
            }
          }
        }
      GQL
      result = HahowBackendB2bSchema.execute(query_string, variables: { id: course.id })
      chapter_result = result['data']['course']['chapters'][0]
      expect(chapter_result)
        .to eq({ id: chapter.id, name: chapter.name, position: chapter.position,
                 createdAt: GraphQL::Types::ISO8601DateTime.coerce_result(chapter.created_at, nil),
                 updatedAt: GraphQL::Types::ISO8601DateTime.coerce_result(chapter.updated_at, nil),
                 units: [{ id: unit.id }.stringify_keys] }.stringify_keys)
    end
  end
end
