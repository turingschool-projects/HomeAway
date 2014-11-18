require 'rails_helper'

RSpec.describe ItemsController, :type => :controller do
  let(:valid_attributes) {
    { title: "Food", description: "Yummy food", price: 2.5 }
  }

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns all items as @items" do
      item = Item.create(valid_attributes)
      get :index
      expect(assigns(:items)).to eq([item])
    end
  end

  describe "GET show" do
    xit "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit" do
    xit "returns http success" do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

end
