require 'LdapTools'

module ControllerHelpers
  def auth(user)
    user = users(user) unless user.is_a?(User)
    expect_any_instance_of(ApplicationController).to receive(:authorize).and_return(true)
  end

  def load_pictures
    Person.all.each do |person|
      File.open('spec/fixtures/files/picture.png') do |picture|
        person.picture = picture
        person.save
      end
    end
  end
end
