# frozen_string_literal: true

class PictureController < ApplicationController
  def show
    picture_url = @person.picture.file.nil? ? default_avatar_path : @person.picture.url
    send_file(picture_url, disposition: 'inline')
  end
end
