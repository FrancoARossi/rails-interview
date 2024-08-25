module Api
  class TodoItemsController < Api::ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      @todo_items = TodoItem.where(todo_list_id: params[:todo_list_id])

      respond_to do |format|
        format.json { render json: @todo_items.to_json }
      end
    end

    def create
      @todo_list = TodoList.find(params[:todo_list_id])

      if @todo_list.todo_items.create(todo_item_params)
        respond_to do |format|
          format.json { render json: @todo_list.todo_items.to_json }
        end
      else
        respond_to do |format|
          format.json { render json: { error: @todo_item.errors } }
        end
      end
    end

    def update
      if @todo_item.update(todo_item_params)
        respond_to do |format|
          format.json { render json: @todo_item.to_json }
        end
      else
        respond_to do |format|
          format.json { render json: { error: @todo_item.errors } }
        end
      end
    end

    def show
      respond_to do |format|
        format.json { render json: @todo_item.to_json }
      end
    end

    def destroy
      if @todo_item.destroy
        respond_to do |format|
          format.json { render json: @todo_item.to_json }
        end
      else
        respond_to do |format|
          format.json { render json: { error: @todo_item.errors } }
        end
      end
    end

    private

    def set_todo_item
      @todo_item = TodoItem.find(params[:id])
    end

    def todo_item_params
      params.require(:todo_item).permit(:title, :description)
    end
  end
end
