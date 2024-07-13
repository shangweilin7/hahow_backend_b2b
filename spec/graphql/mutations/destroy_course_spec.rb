require 'rails_helper'

RSpec.describe Mutations::DestroyCourse, type: :graphql do
  describe '#resolve' do
    context 'Record not found' do
      it 'Returns `Record not found` error message' do
        mutation_string = <<-GQL
          mutation($id: Int!) {
            destroyCourse(input: { id: $id }) {
              id
            }
          }
        GQL
        result = HahowBackendB2bSchema.execute(mutation_string, variables: { id: 1 })
        error_message = result['errors'][0]['message']
        expect(error_message).to eq('Record not found')
      end
    end

    it 'Returns id of course' do
      course = create(:course)
      mutation_string = <<-GQL
        mutation($id: Int!) {
          destroyCourse(input: { id: $id }) {
            id
          }
        }
      GQL
      result = HahowBackendB2bSchema.execute(mutation_string, variables: { id: course.id })
      course_id_result = result['data']['destroyCourse']['id']
      expect(course_id_result).to eq(course.id)
    end
  end
end
