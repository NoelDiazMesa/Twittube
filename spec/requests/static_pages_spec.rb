require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit home_path }

    it { should have_selector('h1',    text: 'Twittube') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: 'Twittube | Homepage' }

    describe "for signed-in users" do
      let(:usuario) { FactoryGirl.create(:usuario) }
      before do
        FactoryGirl.create(:micropost, usuario: usuario, content: "http://www.youtube.com/watch?v=9nqr8BSvoz0", titulo: "Lorem ipsum")
        FactoryGirl.create(:micropost, usuario: usuario, content: "http://www.youtube.com/watch?v=9nqrbgrvoz0", titulo: "Dolor sit amet")
        sign_in usuario
        visit root_path
      end

      it "should render the user's feed" do
        usuario.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:usuario) }
        before do
          other_user.follow!(usuario)
          visit root_path
        end

        it { should have_link("0 following", href: following_usuario_path(usuario)) }
        it { should have_link("1 followers", href: followers_usuario_path(usuario)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Pagina de ayuda') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title', text: full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end
end
