require 'rails_helper'

RSpec.describe "TodoItems", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/todo_item/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/todo_item/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/todo_item/show"
      expect(response).to have_http_status(:success)
    end
  end

end
