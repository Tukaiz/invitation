require 'spec_helper'

describe InvitationsController do
  let(:user)          { FactoryGirl.create(:user) }
  let(:site)         { @site }

  before(:each) do
     stub_required_objects
  end

  context "edit" do
    it "sets up an invitation" do
      post :edit
      expect(assigns(:invitation)).to be_a(InvitationPasswordForm)
    end
  end

  context "update" do
    it "sets up an invitation" do
      put :update,{invitation_password_form:{}}
      expect(assigns(:invitation)).to be_a(InvitationPasswordForm)
    end
    context "when a users password (invitation) is updated successfully" do
      it "attempts to login the user" do
        username = 'test@test.com'
        password = 'test1234'
        InvitationPasswordForm.any_instance.stub(:update).and_return(username)
        authentication = double('a')
        authentication.stub(:access_permitted?).and_return(true)
        controller.stub(:log_login)
        controller.should_receive(:authenticate_and_authorize).
          with(username, password).and_return(authentication)
        put :update,{invitation_password_form:{
          password: password,
          password_confirmation: password}}
      end
      context "when a user is successfully logged in" do
        it "logs the users login" do
          username = 'test@test.com'
          password = 'test1234'
          InvitationPasswordForm.any_instance.stub(:update).and_return(username)
          authentication = double('a')
          authentication.stub(:access_permitted?).and_return(true)
          controller.stub(:authenticate_and_authorize).
            with(username, password).and_return(authentication)
          controller.should_receive(:log_login)
          put :update,{invitation_password_form:{
            password: password,
            password_confirmation: password}}
        end
        it "redirects the user" do
          username = 'test@test.com'
          password = 'test1234'
          InvitationPasswordForm.any_instance.stub(:update).and_return(username)
          authentication = double('a')
          authentication.stub(:access_permitted?).and_return(true)
          controller.stub(:authenticate_and_authorize).
            with(username, password).and_return(authentication)
          controller.stub(:log_login)
          expect(put :update,{invitation_password_form:{
            password: password,
            password_confirmation: password}}).to redirect_to(root_path)
        end
      end
      context "when a users login fails" do
        it "redirects the user to the homepage" do
          username = 'test@test.com'
          password = 'test1234'
          InvitationPasswordForm.any_instance.stub(:update).and_return(username)
          authentication = double('a')
          authentication.stub(:access_permitted?).and_return(false)
          controller.stub(:authenticate_and_authorize).
            with(username, password).and_return(authentication)
          expect(put :update,{invitation_password_form:{
            password: password,
            password_confirmation: password}}).to redirect_to(root_path)
        end
        it "sets a flash error" do
          username = 'test@test.com'
          password = 'test1234'
          InvitationPasswordForm.any_instance.stub(:update).and_return(username)
          authentication = double('a')
          authentication.stub(:access_permitted?).and_return(false)
          controller.stub(:authenticate_and_authorize).
            with(username, password).and_return(authentication)
          put :update,{invitation_password_form:{
            password: password,
            password_confirmation: password}}
          expect(flash[:error]).to_not be_nil
        end
      end
    end
    context "when a users password (invitation) fails to update" do
      it "renders the edit action"
    end
  end
end
