class Company < ApplicationRecord
	has_many :people
	has_many :locations, dependent: :destroy
	has_many :employee_quantities, dependent: :destroy
	
	mount_uploader :picture, PictureUploader
	
	validate :picture_size
	
	
	
	private

  def picture_size
    return if picture.nil? || picture.size < 10.megabytes
    errors.add(:picture, 'grösse kann maximal 10MB sein')
  end
end
