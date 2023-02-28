class Image < ApplicationRecord
  validates_presence_of :filename
  validates_presence_of :attributes
end
