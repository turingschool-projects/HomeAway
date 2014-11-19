require 'rails_helper'

RSpec.describe ItemsController, :type => :controller do
  let(:valid_attributes) {
    { title: "Food", description: "Yummy food", price: 2.5 }
  }
  let(:valid_attributes2) {
    { title: "Good Food", description: "Best food", price: 3.5 }
  }


  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns all items as @items" do
      item = Item.create(valid_attributes)
      item2 = Item.create(valid_attributes2)
      get :index
      expect(assigns(:items)).to eq([item, item2])
    end
  end

  describe "GET show" do
    it "returns http success" do
      item = Item.create(valid_attributes)
      get :show, {id: item.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    it "returns http success" do
      post :create, {item: valid_attributes}
      expect(response).to have_http_status(:redirect)
    end

    it "increases the item count by 1" do
      starting_count = Item.all.count
      post :create, {item: valid_attributes}
      ending_count = Item.all.count
      expect(ending_count).to eq(starting_count + 1)
    end
  end

  describe "GET edit" do
    it "returns http success" do
      item = Item.create(valid_attributes)
      get :edit, {id: item.id}
      expect(response).to have_http_status(:success)
    end
  end

end
