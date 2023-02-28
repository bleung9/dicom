require 'rails_helper'

RSpec.describe "/attributes", type: :request do
  describe "GET /attributes" do
    context "when the request params are valid" do
      it "returns the correct data" do
        tag = Mappings::TAG_TO_VALUE.keys.sample
        value = Mappings::TAG_TO_VALUE[tag]
        Image.create!(filename: "I am a DICOM file.dcm", tags: Hash[value, "Dr. Strange"])

        get "/attributes", params: { tag: tag }

        image = Image.last
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["data"]).to eq("the value of the DICOM tag #{tag} is: #{image.tags[value]}")
      end
    end

    context "when the request params are invalid" do
      it "returns an error" do
        get "/attributes", params: { tag: "0008,00100" }

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)["errors"]).to eq("Invalid DICOM tag format. Please try again.")
      end
    end

    context "when no images have been uploaded" do
      it "returns an error" do
        Image.destroy_all

        get "/attributes", params: { tag: "0008,0010" }

        expect(response.status).to eq(500)
        expect(JSON.parse(response.body)["errors"]).to eq("Please upload a DCM image first.")
      end
    end
  end
end
