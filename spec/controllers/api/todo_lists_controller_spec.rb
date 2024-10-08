require 'rails_helper'

describe Api::TodoListsController do
  let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

  describe '#index' do
    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :index
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      it 'returns a success code' do
        get :index, format: :json

        expect(response.status).to eq(200)
      end

      it 'includes todo list records' do
        get :index, format: :json

        todo_lists = JSON.parse(response.body)

        aggregate_failures 'includes the id and name' do
          expect(todo_lists.count).to eq(1)
          expect(todo_lists[0].keys).to match_array(['id', 'name'])
          expect(todo_lists[0]['id']).to eq(todo_list.id)
          expect(todo_lists[0]['name']).to eq(todo_list.name)
        end
      end
    end
  end

  describe '#show' do
    context "when there's no TodoList with the given ID" do
      it 'raises a record not found error' do
        get :show, params: { id: 10 }, format: :json
        
        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to eq({ "error" => "Couldn't find TodoList with 'id'=10" })
      end
    end

    context "when there's a TodoList with the given ID" do
      it 'returns the TodoList' do
        get :show, params: { id: 1 }, format: :json
        
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq({ "id" => 1, "name" => "Setup RoR project" })
      end
    end
  end

  describe '#create' do
    context "when a valid body is sent" do
      it 'creates the TodoList' do
        post :create, params: { todo_list: { name: "Test" } }, format: :json
        
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq({ "id" => 2, "name" => "Test" })
      end
    end
  end

  describe '#update' do
    context "when a valid body is sent" do
      it 'updates the TodoList' do
        post :update, params: { id: 1, todo_list: { name: "Updated" } }, format: :json
        
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq({ "id" => 1, "name" => "Updated" })
      end
    end
  end

  describe '#destroy' do
    context "when a valid id is sent" do
      it 'deletes the TodoList' do
        post :destroy, params: { id: 1 }, format: :json
        
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq({ "id" => 1, "name" => 'Setup RoR project' })
      end
    end
  end
end
