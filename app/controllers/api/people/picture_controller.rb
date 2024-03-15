# frozen_string_literal: true

module Api::People
  class PictureController < Api::CrudController

    self.permitted_attrs = %i[picture]

    def show
      picture_url = person.picture.file.nil? ? default_avatar_path : person.picture.url
      send_file(picture_url, disposition: 'inline')
    end

    def update
      person.update!(picture: params[:picture])
      render json: { data: { picture_path: picture_api_person_path(params[:id]) } }
    end


    private

    def person
      @person ||= Person.find(params[:id])
    end

    def default_avatar_path
      get_asset_path 'default_avatar.png'
    end
  end
end
