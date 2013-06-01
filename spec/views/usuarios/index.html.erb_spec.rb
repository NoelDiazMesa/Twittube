require 'spec_helper'

describe "usuarios/index" do
  before(:each) do
    assign(:usuarios, [
      stub_model(Usuario,
        :username => "Username",
        :email => "Email",
        :password => "example",
        :password_confirmation => "example",
      ),
      stub_model(Usuario,
        :username => "Username",
        :email => "Email",
        :password => "example",
        :password_confirmation => "example",
      )
    ])
  end

end
