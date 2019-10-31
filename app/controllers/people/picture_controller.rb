# frozen_string_literal: true

module People
  class PictureController < CrudController

    self.permitted_attrs = %i[picture]

    def update
      person.update(picture: params[:picture])
      render json: { data: { picture_path: people_path(params[:person_id]) } }
    end

    def show
      default_avatar_url = "#{Rails.public_path}/default_avatar.png"
      picture_url = person.picture.file.nil? ? default_avatar_url : person.picture.url
      send_file(picture_url, disposition: 'inline')
    end

    private

    def person
      @person ||= Person.find(params[:id])
    end
  end
end
