require 'rails_helper'

RSpec.describe Mutations::CreateCourse, type: :graphql do
  describe '#resolve' do
    context 'invalid' do
      context 'Has same chapter names' do
        it 'returns `Unique chapter names Has same chapter names` error message' do
          mutation = <<-GQL
            mutation($attributes: CourseInputs!) {
              createCourse(input: { attributes: $attributes }) {
                course {
                  id
                }
              }
            }
          GQL
          result = HahowBackendB2bSchema.execute(
            mutation,
            variables: {
              attributes: {
                name: 'course', lecturer: 'lecturer', description: 'description',
                chaptersAttributes: [{
                  name: 'same name', position: 0
                }, {
                  name: 'same name', position: 1
                }]
              }
            }
          )
          error_message = result['errors'][0]['message']
          expect(error_message).to eq('Unique chapter names Has same chapter names')
        end
      end

      context 'Has same chapter positions' do
        it 'returns `Unique chapter positions Has same chapter positions` error message' do
          mutation = <<-GQL
            mutation($attributes: CourseInputs!) {
              createCourse(input: { attributes: $attributes }) {
                course {
                  id
                }
              }
            }
          GQL
          result = HahowBackendB2bSchema.execute(
            mutation,
            variables: {
              attributes: {
                name: 'course', lecturer: 'lecturer', description: 'description',
                chaptersAttributes: [{
                  name: 'name 1', position: 0
                }, {
                  name: 'name 2', position: 0
                }]
              }
            }
          )
          error_message = result['errors'][0]['message']
          expect(error_message).to eq('Unique chapter positions Has same chapter positions')
        end
      end

      context 'Has same unit names' do
        it 'returns `Unique unit names Has same unit names` error message' do
          mutation_string = <<-GQL
            mutation($attributes: CourseInputs!) {
              createCourse(input: { attributes: $attributes }) {
                course {
                  id
                }
              }
            }
          GQL
          result = HahowBackendB2bSchema.execute(
            mutation_string,
            variables: {
              attributes: {
                name: 'course', lecturer: 'lecturer', description: 'description',
                chaptersAttributes: [{
                  name: 'name', position: 0,
                  unitsAttributes: [{
                    name: 'same name', description: 'description', content: 'content', position: 0
                  }, {
                    name: 'same name', description: 'description', content: 'content', position: 1
                  }]
                }]
              }
            }
          )
          error_message = result['errors'][0]['message']
          expect(error_message).to eq('Chapters unique unit names Has same unit names')
        end
      end

      context 'Has same unit positions' do
        it 'returns `Unique unit positions Has same unit positions` error message' do
          mutation_string = <<-GQL
            mutation($attributes: CourseInputs!) {
              createCourse(input: { attributes: $attributes }) {
                course {
                  id
                }
              }
            }
          GQL
          result = HahowBackendB2bSchema.execute(
            mutation_string,
            variables: {
              attributes: {
                name: 'course', lecturer: 'lecturer', description: 'description',
                chaptersAttributes: [{
                  name: 'name', position: 0,
                  unitsAttributes: [{
                    name: 'name1', description: 'description', content: 'content', position: 0
                  }, {
                    name: 'name2', description: 'description', content: 'content', position: 0
                  }]
                }]
              }
            }
          )
          error_message = result['errors'][0]['message']
          expect(error_message).to eq('Chapters unique unit positions Has same unit positions')
        end
      end
    end

    context 'valid' do
      it 'Returns fields of course' do
        mutation_string = <<-GQL
          mutation($attributes: CourseInputs!) {
            createCourse(input: { attributes: $attributes }) {
              course {
                name
              }
            }
          }
        GQL
        result = HahowBackendB2bSchema.execute(
          mutation_string,
          variables: {
            attributes: {
              name: 'course', lecturer: 'lecturer', description: 'description',
              chaptersAttributes: [{
                name: 'name 1', position: 0
              }, {
                name: 'name 2', position: 1
              }]
            }
          }
        )
        course_name_result = result['data']['createCourse']['course']['name']
        expect(course_name_result).to eq('course')
      end
    end
  end
end
