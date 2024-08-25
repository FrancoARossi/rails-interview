module Api
  class TodoListsController < Api::ApplicationController
    before_action :set_todo_list, only: %i[show update destroy]

    # GET /api/todolists
    def index
      @todo_lists = TodoList.all

      respond_to do |format|
        format.json { render json: @todo_lists.as_json }
      end
    end

    def show
      respond_to do |format|
        format.json { render json: @todo_list.as_json }
      end
    end

    def create
      @todo_list = TodoList.new(todo_list_params)

      if @todo_list.save
        respond_to do |format|
          format.json { render json: @todo_list.as_json }
        end
      else
        respond_to do |format|
          format.json { render json: { error: @todo_list.errors } }
        end
      end
    end

    def update
      if @todo_list.update(todo_list_params)
        respond_to do |format|
          format.json { render json: @todo_list.as_json }
        end
      else
        respond_to do |format|
          format.json { render json: { error: @todo_list.errors } }
        end
      end
    end

    def destroy
      if @todo_list.destroy
        respond_to do |format|
          format.json { render json: @todo_list.as_json }
        end
      else
        respond_to do |format|
          format.json { render json: { error: @todo_list.errors } }
        end
      end
    end

    private

    def set_todo_list
      @todo_list = TodoList.find(params[:id]) if params[:id]
    end

    def todo_list_params
      params.require(:todo_list).permit(:name)
    end
  end
end
