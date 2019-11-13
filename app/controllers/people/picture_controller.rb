# frozen_string_literal: true

module People
  class PictureController < CrudController

    self.permitted_attrs = %i[picture]

    def update
      person.update!(picture: params[:picture])
      render json: { data: { picture_path: picture_person_path(params[:id]) } }
    end

    def show
      picture_url = person.picture.file.nil? ? default_avatar_url : person.picture.url
      send_file(picture_url, disposition: 'inline')
    end

    private

    def person
      @person ||= Person.find(params[:id])
    end

    def default_avatar_path
      "#{Rails.public_path}/default_avatar.png"
    end
  end
end
