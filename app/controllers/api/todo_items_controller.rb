module Api
  class TodoItemsController < Api::ApplicationController
    before_action :set_todo_item, only: %i[show update destroy]
    before_action :set_todo_list, only: %i[create index]

    def index
      respond_to do |format|
        format.json { render_success(serialize_items(@todo_list.todo_items)) }
      end
    end

    def show
      respond_to do |format|
        format.json { render_success(serialize_items(@todo_item)) }
      end
    end

    def create
      if @todo_list.todo_items.create(todo_item_params)
        respond_to do |format|
          format.json { render_success(serialize_items(@todo_list.todo_items.last), :created) }
        end
      else
        respond_to do |format|
          format.json { render_error(@todo_list.errors) }
        end
      end
    end

    def update
      if @todo_item.update(todo_item_params)
        respond_to do |format|
          format.json { render_success(serialize_items(@todo_item)) }
        end
      else
        respond_to do |format|
          format.json { render_error(@todo_item.errors) }
        end
      end
    end

    def destroy
      if @todo_item.destroy
        respond_to do |format|
          format.json { render_success(serialize_items(@todo_item)) }
        end
      else
        respond_to do |format|
          format.json { render_error(errors: @todo_item.errors) }
        end
      end
    end

    private

    def set_todo_item
      @todo_item = TodoItem.find(params[:id])
    end

    def set_todo_list
      @todo_list = TodoList.find(params[:todo_list_id])
    end

    def todo_item_params
      params.require(:todo_item).permit(:title, :description, :completed)
    end

    def serialize_items(todo_items)
      todo_items.as_json(except: %i[todo_list_id updated_at created_at])
    end
  end
end
