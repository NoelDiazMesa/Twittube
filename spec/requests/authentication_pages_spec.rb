require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Bienvenido a Twittube') }
    it { should have_selector('title', text: full_title('Bienvenido')) }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Acceder" }

      it { should have_selector('title', text: 'Bienvenido') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Inicio" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      #before { sign_in user }  // Comentado por que se deberia añadir esto.
      before do
        fill_in "Email",    with: usuario.email.upcase
        fill_in "Password", with: usuario.password
        click_button "Acceder"
      end

      it { should have_selector('title', text: usuario.username) }
      it { should have_link('Usuarios', href: usuarios_path) }
      it { should have_link('Perfil', href: usuario_path(usuario)) }
      it { should have_link('Configuracion', href: edit_usuario_path(usuario)) }
      it { should have_link('Cerrar Sesion', href: signout_path) }
      it { should_not have_link('Iniciar Sesion', href: signin_path) }

       describe "followed by signout" do
        before { click_link "Cerrar Sesion" }
        it { should have_link('Iniciar Sesion') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:usuario) { FactoryGirl.create(:usuario) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_usuario_path(usuario) }
          it { should have_selector('title', text: 'Edit user') }
        end

        describe "as wrong user" do
          let(:usuario) { FactoryGirl.create(:usuario) }
          let(:wrong_user) { FactoryGirl.create(:usuario, email: "wrong@example.com") }
          before { sign_in usuario }

          describe "visiting Users#edit page" do
           before { visit edit_usuario_path(wrong_user) }
            it {  should have_selector('title', text: 'Edit user')}
          end
        end
      end
      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "as non-admin user" do
        let(:usuario) { FactoryGirl.create(:usuario) }
        let(:non_admin) { FactoryGirl.create(:usuario) }

        before { sign_in non_admin }

        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete usuario_path(usuario) }
          specify { expect(response).to redirect_to(usuarios_path) }        
        end
      end
      describe "visiting the following page" do
          before { visit following_usuario_path(usuario) }
          it { should have_selector('title', text: 'Following') }
        end

        describe "visiting the followers page" do
          before { visit followers_usuario_path(usuario) }
          it { should have_selector('title', text: 'Followers') }
        end
    end

    describe "for non-signed-in users" do
      let(:usuario) { FactoryGirl.create(:usuario) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_usuario_path(usuario)
          fill_in "Email",    with: usuario.email
          fill_in "Password", with: usuario.password
          click_button "Guardar cambios"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_selector('title', text: 'Edit user')
          end
        end
      end
      describe "in the Users controller" do
        
        describe "visiting the user index" do
          before { visit usuarios_path }
          it { should have_selector('title', text: 'All user') }
        end
      end
      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }          
        end
      end
    end
  end
end