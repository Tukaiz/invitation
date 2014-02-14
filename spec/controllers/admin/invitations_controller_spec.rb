require 'spec_helper'
describe Admin::InvitationsController do
  before(:each) do
    stub_required_objects
    stub_abilities
    @ability.can :manage, :all
  end
  context "new" do
    it "sets up an invitation form" do
      get :new
      expect(assigns(:invitation)).to be_instance_of(InvitationForm)
    end
  end

  context "create" do
    it "sets up an invitation form" do
      InvitationForm.any_instance.stub(:save).and_return(true);
      post :create, {invitation_form: {email: 'test@test.com'}}
      expect(assigns(:invitation)).to be_instance_of(InvitationForm)
    end
    context "when an invitation is saved successfully" do
      it "sets a flash message" do
        InvitationForm.stub(:new).and_return(double('if', save: true))
        post :create, {invitation_form: {email: 'test@test.com'}}
        expect(flash[:notice]).to_not be_nil
      end
      it "renders the new action" do
        InvitationForm.stub(:new).and_return(double('if', save: true))
        post :create, {invitation_form:{email: 'test@test.com'}}
        expect(response).to render_template(:new)
      end
    end
    context "when an invitation fails to save" do
      it "renders the new action" do
        InvitationForm.any_instance.stub(:save).and_return(false)
        InvitationForm.any_instance.stub(:errors).
          and_return([{"email" => "Already exists"}])
        post :create, {invitation_form:{email: 'test@test.com'}}
        expect(response).to render_template(:new)
      end
    end
  end
end
