require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Registrate') }
    it { should have_selector('title', text: full_title('Registrate')) }
  end

  describe "profile page" do
    let(:usuario) { FactoryGirl.create(:usuario) }
    before { visit usuario_path(usuario) }

    it { should have_selector('h1',    text: usuario.username) }
    it { should have_selector('title', text: usuario.username) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Crear cuenta" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(Usuario, :count)
      end
    end

     it "should create a user" do
        expect { click_button submit }.to change(Usuario, :count).by(1)
      end

    describe "with valid information" do
      before do
        fill_in "Nombre",       with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Repite tu password", with: "foobar"
      end

     
	  describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Singup') }
        it { should have_content('error') }
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { Usuario.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.username) }
        it { should have_selector('div.alert.alert-success', text: 'Bienvenido') }
      end

    end
  end

end

