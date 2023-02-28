require 'rails_helper'

RSpec.describe "/images", type: :request do
  describe "POST /images" do
    after(:each) do
      File.delete("storage/test.dcm") if File.exist?("storage/test.dcm")
    end

    context "if the file is a .dcm file" do
      it "renders a successful response" do
        post "/images", params: { image: fixture_file_upload('spec/storage/test.dcm') }

        expect(response.status).to eq(200)
        expect(File.exist?("storage/test.dcm")).to be true
      end
    end

    context "if the request is invalid" do
      context "if no image is attached" do
        it "returns an error" do
          post "/images"

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)["errors"]).to eq("Please ensure an image is uploaded.")
        end
      end

      context "if the file is not a .dcm file" do
        it "returns an error" do
          post "/images", params: { image: fixture_file_upload('spec/storage/test.png') }

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)["errors"]).to eq("test.png is an invalid DICOM file.")
        end
      end
    end
  end
end
