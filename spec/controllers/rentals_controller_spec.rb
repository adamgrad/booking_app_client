require "rails_helper"

RSpec.describe RentalsController, type: :controller do
  describe "#create" do
    context "With valid data" do
      let(:rental) { form_rental_create_hash("Test", 450) }
      subject { post :create, params: rental}

      it "responds successfully" do
        VCR.use_cassette "create_rental" do
          post :create, params: rental
        end
        expect(response.message).to eq "Found"
      end

      it "returns a 302 response" do
        VCR.use_cassette "create_rental" do
          post :create, params: rental
        end
        expect(response).to have_http_status 302
      end

      it "redirects to rental" do
        VCR.use_cassette "create_rental" do
          expect(subject).to redirect_to rental_url
        end
      end
    end

    context "With invalid data" do
      let (:invalid_rental) { form_rental_create_hash("", "") }
      subject { post :create, params: invalid_rental }

      it "redirects to #new" do
        VCR.use_cassette "create_invalid_rental" do
          expect(subject).to render_template :new
        end
      end
    end
  end

  describe "#index" do
    it "responds successfully" do
      VCR.use_cassette "rentals#index" do
        get :index
        expect(response).to be_success
      end
    end

    it "returns a 200 response" do
      VCR.use_cassette "rentals#index" do
        get :index
        expect(response).to have_http_status 200
      end
    end
  end

  describe "#show" do
    it "responds successfully" do
      VCR.use_cassette "rentals#show" do
        get :show, params: { id: 1 }
        expect(response).to be_success
      end
    end

    it "returns a 200 response" do
      VCR.use_cassette "rentals#show" do
        get :show, params: { id: 1 }
        expect(response).to have_http_status 200
      end
    end
  end

  describe "#update" do
    context "with valid data" do
      let(:rental) { form_rental_update_hash(1, "Test Updated", 499) }
      subject { patch :update, params: rental }

      it "responds successfully" do
        VCR.use_cassette "rentals#update" do
          subject
        end
        expect(response.message).to eq "Found"
      end

      it "returns a 302 response" do
        VCR.use_cassette "rentals#update" do
          subject
        end
        expect(response).to have_http_status 302
      end

      it "redirects to rental" do
        VCR.use_cassette "rentals#update" do
          expect(subject).to redirect_to "/rentals"
        end
      end
    end

    context "with invalid data" do
      let(:rental) { form_rental_update_hash(1, "", "") }
      subject { patch :update, params: rental }

      it "redirects to #new" do
        VCR.use_cassette "rentals#update_invalid" do
          expect(subject).to render_template :edit
        end
      end
    end
  end

  describe "#destroy" do
    subject { delete :destroy, params: { id: 1 } }
    it "returns a 302 response" do
      VCR.use_cassette "rentals#destroy" do
        subject
      end
      expect(response).to have_http_status 302
    end

    it "redirects to /rentals" do
      VCR.use_cassette "rentals#destroy" do
        expect(subject).to redirect_to "/rentals"
      end
    end
  end

  def form_rental_create_hash(name, daily_rate)
    { rental: { name: name, daily_rate: daily_rate } }
  end

  def form_rental_update_hash(id, name, daily_rate)
    { id: id, rental: { name: name, daily_rate: daily_rate } }
  end

  def rental_url
    response.body[35..60]
  end
end
