require 'rails_helper'

RSpec.describe Types::CourseType, type: :graphql do
  describe 'fields' do
    context 'Record not found' do
      it 'Returns `Record not found` error message' do
        query_string = <<-GQL
          query($id: Int!) {
            course(id: $id) {
              id
            }
          }
        GQL
        result = HahowBackendB2bSchema.execute(query_string, variables: { id: 1 })
        error_message = result['errors'][0]['message']
        expect(error_message).to eq('Record not found')
      end
    end

    it 'Returns fields of course' do
      fields = described_class.fields.keys - ['chapters']
      course = create(:course)
      chapter = create(:chapter, course:)
      query_string = <<-GQL
        query($id: Int!) {
          course(id: $id) {
            #{fields.join("\n")}
            chapters {
              id
            }
          }
        }
      GQL
      result = HahowBackendB2bSchema.execute(query_string, variables: { id: course.id })
      course_result = result['data']['course']
      expect(course_result)
        .to eq({ id: course.id, name: course.name, lecturer: course.lecturer,
                 description: course.description,
                 createdAt: GraphQL::Types::ISO8601DateTime.coerce_result(course.created_at, nil),
                 updatedAt: GraphQL::Types::ISO8601DateTime.coerce_result(course.updated_at, nil),
                 chapters: [{ id: chapter.id }.stringify_keys] }.stringify_keys)
    end
  end
end
