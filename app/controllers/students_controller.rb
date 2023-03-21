class StudentsController < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  
      def index
          students = Student.all
          render json: students
      end
  
      def show
        student = find_student
        render json: student
      end
      
      def destroy
        student = find_student
        student.destroy
        head :no_content
      end
  
      def create
        student = Student.create!(student_params)
        render json: student.to_json(except: [:created_at, :updated_at]), status: :created
      end

      def update
        student = find_student
        student = student.update(student_params)
        render json: find_student.to_json(except: [:created_at, :updated_at]), status: :created
      end

  private

    def find_student
      Student.find(params[:id])
    end
  
    def student_params
      params.permit(:name, :age, :instructor_id)
    end
  
    def render_unprocessable_entity_response(invalid)
      render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
  
    def render_not_found_response
       render json: { error: "student not found" }, status: :not_found
    end

end
