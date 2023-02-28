class AttributesController < ApplicationController
  STORAGE_LOCATION = 'storage'

  protect_from_forgery with: :null_session

  def fetch_attribute
    tag = params[:tag]
    # optimization: store this as a hash instead
    if Mappings::TAG_TO_VALUE.keys.exclude?(tag)
      render :json => { errors: "Invalid DICOM tag format. Please try again." }, :status => :bad_request
      return
    end

    # in a production app, we can cache this information
    # for the purposes of this assignment, we will return the tag for the
    # most recently uploaded image from the database
    image = Image.last
    if image.blank?
      render :json => { errors: "Please upload a DCM image first." }, :status => :internal_server_error
    else
      value = Image.last.tags[Mappings::TAG_TO_VALUE[tag]] || "NOT INDICATED"
      render :json => { data: "the value of the DICOM tag #{tag} is: #{value}" }, :status => :ok
    end
  end
end
