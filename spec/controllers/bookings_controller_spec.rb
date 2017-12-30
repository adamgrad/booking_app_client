require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  describe "#create" do
    context "With valid data" do
      let(:booking) { booking_create_hash(1, DateTime.now, DateTime.now + 5, "test@email.com") }
      context "With HTML format" do
        subject { post :create, format: :html, params: booking }
        it "responds successfully" do
          VCR.use_cassette "bookings_post" do
            subject
          end
          expect(response.message).to eq "Found"
        end

        it "returns a 302 status code" do
          VCR.use_cassette "bookings_post" do
            subject
          end
          expect(response).to have_http_status 302
        end

        it "redirects to root_path" do
          VCR.use_cassette "bookings_post" do
            expect(subject).to redirect_to root_path
          end
        end
      end

      context "With JS format" do
        let(:booking) { booking_create_hash(1, DateTime.now, DateTime.now + 5, "test@email.com") }

        it "responds successfully" do
          VCR.use_cassette "bookings_post_js" do
            post :create, format: :js, params: booking
          end
          expect(response).to be_success
        end

        it "returns a 200 response" do
          VCR.use_cassette "bookings_post_js" do
            post :create, format: :js, params: booking
          end
          expect(response).to have_http_status 200
        end
      end
    end

    context "With invalid data" do
      let(:booking) { booking_create_hash(1, DateTime.now, DateTime.now + 5, "") }

      context "With JS format" do
        subject { post :create, format: :js, params: booking }

        it "renders #new" do
          VCR.use_cassette "bookings_post_js_invalid" do
            expect(subject).to render_template :new
          end
        end
      end

      context "With HTML format" do
        subject { post :create, format: :html, params: booking}

        it "renders #new" do
          VCR.use_cassette "bookings_post_invalid" do
            expect(subject).to render_template :new
          end
        end
      end
    end
  end

  describe "#index" do
    it "responds successfully" do
      VCR.use_cassette "bookings_index" do
        get :index
      end
      expect(response).to be_success
    end

    it "returns a 200 response" do
      VCR.use_cassette "bookings_index" do
        get :index
      end
      expect(response).to have_http_status 200
    end
  end

  describe "#show" do
    it "responds successfully" do
      VCR.use_cassette "bookings_show" do
        get :show, params: { id: 1 }
      end
      expect(response).to be_success
    end

    it "returns a 200 response" do
      VCR.use_cassette "bookings_show" do
        get :show, params: { id: 1 }
      end
      expect(response).to have_http_status 200
    end
  end

  describe "#update" do
    context "with valid data" do
      let(:booking) { booking_update_hash(1, DateTime.now, DateTime.now + 5, "new@mail.com") }
      subject { patch :update, params: booking }
      it "responds successfully" do
        VCR.use_cassette "bookings_update_valid" do
          subject
        end
        expect(response.message).to eq "Found"
      end

      it "returns a 302 response" do
        VCR.use_cassette "bookings_update_valid" do
          subject
        end
        expect(response).to have_http_status 302
      end

      it "redirects to bookings_path" do
        VCR.use_cassette "bookings_update_valid" do
          expect(subject).to redirect_to bookings_path
        end
      end
    end

    context "with invalid data" do
      let(:booking) { booking_update_hash(1, DateTime.now, DateTime.now + 5, "") }
      subject { patch :update, params: booking }

      it "renders #edit" do
        VCR.use_cassette "bookings_update_invalid" do
          expect(subject).to render_template :edit
        end
      end
    end
  end

  describe "#destroy" do
    subject { delete :destroy, params: { id: 1 } }
    it "returns a 302 response" do
      VCR.use_cassette "bookings_destroy" do
        subject
      end
      expect(response.message).to eq "Found"
    end

    it "redirects to bookings_path" do
      VCR.use_cassette "bookings_destroy" do
        expect(subject).to redirect_to bookings_path
      end
    end
  end

  def booking_create_hash(rental_id, start_at, end_at, client_email )
    { booking: { rental_id: rental_id, start_at: start_at, end_at: end_at, client_email: client_email } }
  end

  def booking_update_hash(booking_id, start_at, end_at, client_email)
    { id: booking_id, booking:
      { start_at: start_at, end_at: end_at, client_email: client_email }
    }
  end
end
