describe PictureUploader do
  it 'sets extension whitelist' do
    white_list = '.jpg,.jpeg,.gif,.png'
    expect(PictureUploader.accept_extensions).to eq(white_list)
  end
end
