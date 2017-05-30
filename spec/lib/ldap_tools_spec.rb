require 'rails_helper'

describe LdapTools do
  describe "validation" do
    it "cannot login with invalid username" do
      assert_raises ActiveRecord::StatementInvalid do
        LdapTools.send(:check_username, "$invalid_username?")
      end
    end

    it "can login with valid username" do
      LdapTools.send(:check_username, "validUsername")
    end
  end
end
