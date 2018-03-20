class Company < ApplicationRecord
	has_many :people
	has_many :locations
	has_many :employee_quantities
	
	mount_uploader :picture, PictureUploader
	
	validate :picture_size
	
	
	
	private

  def picture_size
    return if picture.nil? || picture.size < 10.megabytes
    errors.add(:picture, 'grösse kann maximal 10MB sein')
  end
end
