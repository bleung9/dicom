require 'dicom'

class ImagesController < ApplicationController
  include DICOM

  STORAGE_LOCATION = 'storage'

  protect_from_forgery with: :null_session

  def upload
    image = params[:image]
    if image.blank?
      render :json => { errors: "Please ensure an image is uploaded." }, :status => :bad_request
      return
    end

    filename = image.original_filename
    dcm = DObject.read(image.tempfile.path)
    unless dcm.read?
      render :json => { errors: "#{filename} is an invalid DICOM file." }, :status => :bad_request
      return
    end

    # save to local storage
    FileUtils.mv image.tempfile, "#{STORAGE_LOCATION}/#{filename}"

    # the following could be done with a background job worker
    # after the user uploads the image, they could be notified that the image is being processed
    # worker processes the image, tags are saved to the database, and the user is then notified
    # I'm storing all attributes as a jsonb for the sake of simplicity
    Image.create(filename: filename, tags: dcm.to_hash.transform_keys{|k| k.titleize.gsub(/\s+/, "").gsub(/\W+/, '').underscore})

    # PNG conversion should also be done in a background job
    # dcm.image.normalize.write("STORAGE_LOCATION/#{filename.split(".").first}.png")

    head :ok
  rescue Errno::ENOENT, ActiveRecord::RecordInvalid
    render :json => { errors: "#{file_name} failed to save. Please try again." }, :status => :internal_server_error
  end

  def view_image
    render file: "#{STORAGE_LOCATION}/IM000024.png"
  end
end
