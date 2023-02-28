# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  post 'images' => 'images#upload'
  get 'images' => 'images#view_image'

  get 'attributes' => 'attributes#fetch_attribute'
end
