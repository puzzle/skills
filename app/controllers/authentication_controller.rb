require 'LdapTools'

class AuthenticationController < ApplicationController
  skip_before_action :authorize
  
  def sign_in
    username = params[:username]
    password = params[:password]

    return render_unauthorized unless username.present? && password.present?
    
    json = User.authenticate(username, password)
    
    if json[:error].nil?
      return render json: json
    end
    render_unauthorized(json)
  end
end
