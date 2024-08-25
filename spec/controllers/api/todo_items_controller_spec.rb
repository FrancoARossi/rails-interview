require 'rails_helper'

describe Api::TodoItemsController do
  let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }
  let!(:todo_item_1) { TodoItem.create(title: 'Install dependencies', description: 'Run bundler to install dependencies', todo_list:) }
  let!(:todo_item_2) { TodoItem.create(title: 'Setup db', description: 'Run "bin/rails db:migrate & bin/rails db:seed"', todo_list:) }

  describe '#index' do
    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :index, params: { todo_list_id: todo_list.id }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      it 'returns a success code' do
        get :index, format: :json, params: { todo_list_id: todo_list.id }

        expect(response.status).to eq(200)
      end

      it 'includes todo list records' do
        get :index, format: :json, params: { todo_list_id: todo_list.id }

        todo_items = JSON.parse(response.body)

        expect(response.status).to eq(200)
        aggregate_failures 'includes the id and name' do
          expect(todo_items.count).to eq(2)
          expect(todo_items[0].keys).to match_array(['id', 'title', 'description', 'completed'])
        end
      end
    end
  end

  describe '#show' do
    context "when there's no TodoItem with the given ID" do
      it 'raises a record not found error' do
        get :show, format: :json, params: { todo_list_id: todo_list.id, id: 10 }
        
        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to eq({ "error" => "Couldn't find TodoItem with 'id'=10" })
      end
    end

    context "when there's a TodoItem with the given ID" do
      it 'returns the TodoItem' do
        get :show, format: :json, params: { todo_list_id: todo_list.id, id: 1 }
        
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(todo_item_1.as_json(except: %i[updated_at created_at todo_list_id]))
      end
    end
  end

  describe '#create' do
    context "when a valid body is sent" do
      it 'creates the TodoItem' do
        post :create, format: :json, params: { todo_list_id: todo_list.id, todo_item: { \
          title: "Test",
          description: "Test description" \
        } }
        
        expect(response.status).to eq(201) # :created status
        expect(JSON.parse(response.body)).to eq(todo_list.todo_items.last.as_json(except: %i[updated_at created_at todo_list_id]))
      end
    end
  end

  describe '#update' do
    context "when a valid body is sent" do
      it 'updates the TodoItem' do
        post :update, format: :json, params: { \
          todo_list_id: todo_list.id, 
          id: 1, 
          todo_item: { \
            title: "Updated",
            completed: true \
          } 
        }
        
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq({\
          **todo_item_1.as_json(except: %i[updated_at created_at todo_list_id]),
          "title" => "Updated", 
          "completed" => true \
        })
      end
    end
  end

  describe '#destroy' do
    context "when a valid id is sent" do
      it 'deletes the TodoItem' do
        post :destroy, format: :json, params: { todo_list_id: todo_list.id, id: 1 }
        
        expect(JSON.parse(response.body)).to eq(todo_item_1.as_json(except: %i[updated_at created_at todo_list_id]))
        expect(response.status).to eq(200)
      end
    end
  end
end
