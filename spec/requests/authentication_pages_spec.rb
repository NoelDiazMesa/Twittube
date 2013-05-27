require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before { sign_in user }
      #before do
       fill_in "Email",    with: usuario.email.upcase
        fill_in "Password", with: usuario.password
        click_button "Sign in"
      #end

      it { should have_link('Users',    href: usuarios_path) }
      it { should have_selector('title', text: usuario.username) }
      it { should have_link('Profile', href: usuario_path(usuario)) }
      it { should have_link('Settings', href: edit_user_path(usuario)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

       describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:usuario) { FactoryGirl.create(:usuario) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_usuarios_path(usuario)
          fill_in "Email",    with: usuario.email
          fill_in "Password", with: usuario.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_usuario_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put usuario_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        describe "visiting the user index" do
          before { visit usuarios_path }
          it { should have_selector('title', text: 'Sign in') }
        end
      end
    end
    describe "as wrong user" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:wrong_usuario) { FactoryGirl.create(:usuario, email: "wrong@example.com") }
      before { sign_in usuario }

      describe "visiting Users#edit page" do
        before { visit edit_usuario_path(wrong_usuario) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put usuario_path(wrong_usuario) }
        specify { response.should redirect_to(root_path) }
      end
    end
    describe "as non-admin user" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      let(:non_admin) { FactoryGirl.create(:usuario) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete usuario_path(usuario) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
end


