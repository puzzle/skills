require 'rails_helper'

describe People::PictureController do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
  end

  it 'should show default_avatar' do
    get :show, params:{ id: bob.id }

    default_avatar_md5 = '96643270fe346cc83165128dfcfccd4c'

    expect(response.status).to eq(200)
    expect(Digest::MD5.hexdigest(response.body)).to eq(default_avatar_md5)
  end

  it 'should update picture' do
    process :update, method: :put, params: { id: bob.id, picture: fixture_file_upload('picture.png', 'image/png') }

    path = json['data']['picture_path']

    bob.reload

    expect(response.status).to eq(200)
    expect(bob['picture']).to eq('picture.png')
    expect(path).to eq("/people/#{bob.id}/picture")

    process :show, method: :get , params: { id: bob.id }

    new_picture_md5 = 'c903aeff2bec840bd7c028631bd56596'

    expect(Digest::MD5.hexdigest(response.body)).to eq(new_picture_md5)
  end

  private

  def bob
    @bob ||= people(:bob)
  end
end
