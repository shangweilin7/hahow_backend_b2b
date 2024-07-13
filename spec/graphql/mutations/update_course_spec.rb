require 'rails_helper'

RSpec.describe Mutations::UpdateCourse, type: :graphql do
  describe '#resolve' do
    context 'invalid' do
      context 'Has same chapter names' do
        it 'Returns `Unique chapter names Has same chapter names` error message' do
          course = create(:course)
          chapter1 = create(:chapter, name: 'name1', position: 0, course:)
          chapter2 = create(:chapter, name: 'name2', position: 1, course:)
          mutation_string = <<-GQL
            mutation($id: Int!, $attributes: CourseInputs!) {
              updateCourse(input: { id: $id, attributes: $attributes }) {
                course {
                  id
                }
              }
            }
          GQL
          result = HahowBackendB2bSchema.execute(
            mutation_string,
            variables: {
              id: course.id,
              attributes: {
                chaptersAttributes: [{ id: chapter1.id, name: chapter2.name }]
              }
            }
          )
          error_message = result['errors'][0]['message']
          expect(error_message).to eq('Unique chapter names Has same chapter names')
        end
      end

      context 'Has same chapter positions' do
        it 'Returns `Unique chapter positions Has same chapter positions` error message' do
          course = create(:course)
          chapter1 = create(:chapter, name: 'name1', position: 0, course:)
          chapter2 = create(:chapter, name: 'name2', position: 1, course:)
          mutation_string = <<-GQL
            mutation($id: Int!, $attributes: CourseInputs!) {
              updateCourse(input: { id: $id, attributes: $attributes }) {
                course {
                  id
                }
              }
            }
          GQL
          result = HahowBackendB2bSchema.execute(
            mutation_string,
            variables: {
              id: course.id,
              attributes: {
                chaptersAttributes: [{ id: chapter1.id, position: chapter2.position }]
              }
            }
          )
          error_message = result['errors'][0]['message']
          expect(error_message).to eq('Unique chapter positions Has same chapter positions')
        end
      end

      context 'Has same unit names' do
        it 'Returns `Unique unit names Has same unit names` error message' do
          course = create(:course)
          chapter = create(:chapter, course:)
          unit1 = create(:unit, name: 'name1', position: 0, chapter:)
          unit2 = create(:unit, name: 'name2', position: 1, chapter:)
          mutation_string = <<-GQL
            mutation($id: Int!, $attributes: CourseInputs!) {
              updateCourse(input: { id: $id, attributes: $attributes }) {
                course {
                  id
                }
              }
            }
          GQL
          result = HahowBackendB2bSchema.execute(
            mutation_string,
            variables: {
              id: course.id,
              attributes: {
                chaptersAttributes: [{
                  id: chapter.id,
                  unitsAttributes: [{
                    id: unit1.id, name: unit2.name
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
        it 'Returns `Unique unit positions Has same unit positions` error message' do
          course = create(:course)
          chapter = create(:chapter, course:)
          unit1 = create(:unit, name: 'name1', position: 0, chapter:)
          unit2 = create(:unit, name: 'name2', position: 1, chapter:)
          mutation_string = <<-GQL
            mutation($id: Int!, $attributes: CourseInputs!) {
              updateCourse(input: { id: $id, attributes: $attributes }) {
                course {
                  id
                }
              }
            }
          GQL
          result = HahowBackendB2bSchema.execute(
            mutation_string,
            variables: {
              id: course.id,
              attributes: {
                chaptersAttributes: [{
                  id: chapter.id,
                  unitsAttributes: [{
                    id: unit1.id, position: unit2.position
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
        course = create(:course)
        chapter = create(:chapter, course:)
        unit = create(:unit, chapter:)
        mutation_string = <<-GQL
          mutation($id: Int!, $attributes: CourseInputs!) {
            updateCourse(input: { id: $id, attributes: $attributes }) {
              course {
                name
              }
            }
          }
        GQL
        result = HahowBackendB2bSchema.execute(
          mutation_string,
          variables: {
            id: course.id,
            attributes: {
              name: 'new course', chaptersAttributes: [{
                id: chapter.id, name: 'new chapter',
                unitsAttributes: [{
                  id: unit.id, name: 'new unit'
                }]
              }]
            }
          }
        )
        course_name_result = result['data']['updateCourse']['course']['name']
        expect(course_name_result).to eq('new course')
      end
    end
  end
end
