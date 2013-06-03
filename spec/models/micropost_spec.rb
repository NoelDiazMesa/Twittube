require 'spec_helper'

describe Micropost do

  let(:usuario) { FactoryGirl.create(:usuario) }
  before { @micropost = usuario.microposts.build(content: "http://www.youtube.com/watch?v=xxxxxxxxxxx", titulo: "Ejemplo") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:usuario_id) }
  it { should respond_to(:usuario) }
  it { should respond_to(:titulo) }
  its(:usuario) { should == usuario }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to usuario_id" do
      expect do
        Micropost.new(usuario_id: usuario.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  describe "when user_id is not present" do
    before { @micropost.usuario_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with blank titulo" do
    before { @micropost.titulo = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
  describe "with titulo that is too long" do
    before { @micropost.titulo = "a" * 141 }
    it { should_not be_valid }
  end
end