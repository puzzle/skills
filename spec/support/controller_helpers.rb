require 'ldap_tools'

module ControllerHelpers
  def auth(user)
    users(user) unless user.is_a?(User)
    expect_any_instance_of(SkillsController).to receive(:authorize_admin).and_return(true)
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
