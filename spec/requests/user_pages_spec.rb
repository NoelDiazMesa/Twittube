#!encoding:UTF-8
require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    before do
      sign_in FactoryGirl.create(:usuario)
      FactoryGirl.create(:usuario, username: "Bob", email: "bob@example.com")
      FactoryGirl.create(:usuario, username: "Ben", email: "ben@example.com")
      visit usuarios_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:usuario) } }
      after(:all)  { Usuario.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        Usuario.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.username)
        end
      end
    end

     describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit usuarios_path
        end

        it { should have_link('delete', href: usuarios_path(Usuario.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(Usuario, :count).by(-1)
        end
        it { should_not have_link('delete', href: usuarios_path(admin)) }
      end
    end


  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sing up') }
    it { should have_selector('title', text: full_title('Sing up')) }
  end

   describe "profile page" do
    let(:usuario) { FactoryGirl.create(:usuario) }
    let!(:m1) { FactoryGirl.create(:micropost, usuario: usuario, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, usuario: usuario, content: "Bar") }

    before { visit usuario_path(usuario) }

    it { should have_selector('h1',    text: usuario.username) }
    it { should have_selector('title', text: usuario.username) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(usuario.microposts.count) }
    end
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
      it { should have_content("Actualiza tu perfil") }
      it { should have_selector('title', text: full_title('Edit user'))}
      it { should have_link('Cambiar', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Guardar cambios" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before { sign_in usuario }

      it { should have_selector('title', text: usuario.username) }
      it { should have_link('Perfil',     href: usuario_path(usuario)) }
      it { should have_link('Configuracion',    href: edit_usuario_path(usuario)) }
      it { should have_link('Cerrar Sesion',    href: signout_path) }
      it { should_not have_link('Iniciar Sesion', href: signin_path) }
    end

  end
end

