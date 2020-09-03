require 'rails_helper'

RSpec.describe 'Car API', type: :request do
  # initialize test data 
  let!(:cars) { create_list(:car, 10) }
  let(:car_id) { cars.first.id }

  # Test suite for GET /cars
  describe 'GET /cars' do
    # make HTTP get request before each example
    before { get '/cars' }

    it 'returns cars' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /cars/:id
  describe 'GET /cars/:id' do
    before { get "/cars/#{car_id}" }

    context 'when the record exists' do
      it 'returns the car' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(car_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:car_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Car/)
      end
    end
  end

  # Test suite for POST /cars
  describe 'POST /cars' do
    # valid payload
    let(:valid_attributes) { { make: 'toyota', color: 'red', year: 2015, price: 10000 } }

    context 'when the request is valid' do
      before { post '/cars', params: valid_attributes }

      it 'creates a car' do
        expect(json['make']).to eq('toyota')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/cars', params: { make: 'anything' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Color can't be blank, Year can't be blank, Price can't be blank/)
      end
    end
  end

  # Test suite for PUT /cars/:id
  describe 'PUT /cars/:id' do
    let(:valid_attributes) { { make: 'toyota', color: 'red', year: 2015, price: 10000 } }

    context 'when the record exists' do
      before { put "/cars/#{car_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /cars/:id
  describe 'DELETE /cars/:id' do
    before { delete "/cars/#{car_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end