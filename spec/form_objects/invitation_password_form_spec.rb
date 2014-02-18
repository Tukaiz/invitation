require 'spec_helper'
describe Invitation::InvitationPasswordForm do

  let(:args) { {  invitation_token: 123,
                  password: "password",
                  password_confirmation: "password"} }
  let(:inv_password_form) { Invitation::InvitationPasswordForm.new(args) }
  let(:result) { true }
  before(:each){
    HTTParty.stub(:put).and_return(
      double("response",
        headers: {"account_email" => "hey@im.ok"},
        success?: result)
    )
  }


  context "update" do
    context "when it is valid" do
      it "attempts to update the invitation on auth server" do
        Invitation::InvitationPasswordForm.any_instance.stub(:valid?).and_return(true)
        res = double('r')
        res.stub(:success?).and_return(true)
        res.stub(:headers).and_return({"account_email" => 'test@test.com'})
        HTTParty.should_receive(:put).and_return(res)
        subject.update
      end
      context "when update attempt successful" do
        it "returns true" do
          Invitation::InvitationPasswordForm.any_instance.stub(:valid?).and_return(true)
          res = double('r')
          res.stub(:success?).and_return(true)
          HTTParty.stub(:put).and_return(res)
          expect(subject.update).to eq(true)
        end
      end

      context "when update is unsuccessful" do
        context "given there are error messages" do
          it "adds the response errors to the forms errors" do
            Invitation::InvitationPasswordForm.any_instance.stub(:valid?).and_return(true)
            res = double('r')
            res.stub(:success?).and_return(false)
            message = 'is invalid'
            error = {"email" => [message]}
            res.stub(:[]).and_return(error)
            HTTParty.stub(:put).and_return(res)
            subject.update
            expect(subject.errors.messages[:email]).to eq([message])
          end
        end
        it "returns false" do
          Invitation::InvitationPasswordForm.any_instance.stub(:valid?).and_return(true)
          res = double('r')
          res.stub(:success?).and_return(false)
          res.stub(:[]).and_return([])
          HTTParty.stub(:put).and_return(res)
          subject.update
          expect(subject.update).to be_false
        end
      end
    end
    context "when it is not valid" do
      it "returns false" do
        Invitation::InvitationPasswordForm.any_instance.stub(:valid?).and_return(false)
        expect(subject.update).to be_false
      end
    end
  end
end
