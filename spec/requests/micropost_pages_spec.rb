require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:usuario) { FactoryGirl.create(:usuario) }
  before { sign_in usuario }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Publicar" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Publicar" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "http://www.youtube.com/watch?v=9nqr8BSvoz0" } 
      before { fill_in 'micropost_titulo', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Publicar" }.to change(Micropost, :count).by(1)
      end
    end
  end
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, usuario: usuario) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end