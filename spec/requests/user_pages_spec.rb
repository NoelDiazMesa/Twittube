require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sing up') }
    it { should have_selector('title', text: full_title('Sing up')) }
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

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sing up') }
        it { should have_content('error') }
      end
    end

     

    describe "with valid information" do
      before do
        fill_in "Nombre",       with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
	  
	  it "should create a user" do
        expect { click_button submit }.to change(Usuario, :count).by(1)
      end
     
	describe "after saving the user" do
        before { click_button submit }
        let(:user) { Usuario.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.username) }
        it { should have_selector('div.alert.alert-success', text: 'Bienvenido') }
      end    
    end
  end

  describe "edit" do
    let(:usuario) { FactoryGirl.create(:usuario) }
    before { visit edit_usuario_path(usuario) }

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_selector('title', text: full_title('Edit user'))}
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: usuario.password
        fill_in "Confirm Password", with: usuario.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(usuario.reload.username).to  eq new_name }
      specify { expect(usuario.reload.email).to eq new_email }
    end
  end
end

