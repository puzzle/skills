# frozen_string_literal: true

module People
  class PictureController < CrudController

    self.permitted_attrs = %i[picture]

    def show
      picture_url = person.picture.file.nil? ? default_avatar_path : person.picture.path
      send_file(picture_url, disposition: 'inline')
    end

    def update
      person.update!(picture: params[:picture])
      render json: { data: { picture_path: picture_person_path(params[:id]) } }
    end

    private

    def model_class
      Person
    end

    def person
      @person ||= Person.find(params[:id])
    end

    def default_avatar_path
      get_asset_path 'default_avatar.png'
    end
  end
end
