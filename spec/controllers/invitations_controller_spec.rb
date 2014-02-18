require 'spec_helper'

describe Invitation::InvitationsController do
  let(:user)          { FactoryGirl.create(:user) }
  let(:site)         { @site }
  routes { Invitation::Engine.routes }

  context "new" do
    it "sets up an invitation form" do
      get :new, use_route: :invitation
      expect(assigns(:invitation)).to be_instance_of(Invitation::InvitationForm)
    end
  end

  context "create" do
    it "sets up an invitation form" do
      Invitation::InvitationForm.any_instance.stub(:save).and_return(true);
      post :create, {invitation_form: {email: 'test@test.com'}, use_route: :invitation}
      expect(assigns(:invitation)).to be_instance_of(Invitation::InvitationForm)
    end
    context "when an invitation is saved successfully" do
      it "sets a flash message" do
        Invitation::InvitationForm.stub(:new).and_return(double('if', save: true))
        post :create, {invitation_form: {email: 'test@test.com'},use_route: :invitation}
        expect(flash[:notice]).to_not be_nil
      end
      it "renders the new action" do
        Invitation::InvitationForm.stub(:new).and_return(double('if', save: true))
        post :create, {invitation_form:{email: 'test@test.com'},use_route: :invitation}
        expect(response).to redirect_to new_invitation_path
      end
    end
    context "when an invitation fails to save" do
      it "renders the new action" do
        Invitation::InvitationForm.any_instance.stub(:save).and_return(false)
        Invitation::InvitationForm.any_instance.stub(:errors).
          and_return([{"email" => "Already exists"}])
        post :create, {invitation_form:{email: 'test@test.com'},use_route: :invitation}
        expect(response).to render_template(:new)
      end
    end
  end

  context "edit" do
    it "sets up an invitation" do
      post :edit, use_route: :invitation
      expect(assigns(:invitation)).to be_a(Invitation::InvitationPasswordForm)
    end
  end

  context "update" do
    it "sets up an invitation" do
      put :update,{invitation_password_form:{}, use_route: :invitation}
      expect(assigns(:invitation)).to be_a(Invitation::InvitationPasswordForm)
    end
    context "when a users password (invitation) is updated successfully" do
      it "redirects the user to the root path" do
        username = 'test@test.com'
        password = 'test1234'
        Invitation::InvitationPasswordForm.any_instance.stub(:update).and_return(username)
        put :update,{invitation_password_form:{
          password: password,
          password_confirmation: password}, use_route: :invitation}
         expect(response).to redirect_to('/')
      end
    end
  end
end
