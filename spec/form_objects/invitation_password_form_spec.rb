require 'spec_helper'
describe InvitationPasswordForm do

  let(:args) { {  invitation_token: 123,
                  password: "password",
                  password_confirmation: "password"} }
  let(:inv_password_form) { InvitationPasswordForm.new(args) }
  let(:result) { true }
  before(:each){
    HTTParty.stub(:put).and_return(
      double("response",
        headers: {"account_email" => "hey@im.ok"},
        success?: result)
    )
  }

  describe "account_email" do
    it "should have an account_email" do
      expect(inv_password_form.account_email).to eq("hey@im.ok")
    end
  end


  context "update" do
    context "when it is valid" do
      it "attempts to update the invitation on auth server" do
        InvitationPasswordForm.any_instance.stub(:valid?).and_return(true)
        res = double('r')
        res.stub(:success?).and_return(true)
        res.stub(:headers).and_return({"account_email" => 'test@test.com'})
        HTTParty.should_receive(:put).and_return(res)
        subject.update
      end
      context "when update attempt successful" do
        it "returns the account_email header" do
          InvitationPasswordForm.any_instance.stub(:valid?).and_return(true)
          email = 'test@test.com'
          res = double('r')
          res.stub(:success?).and_return(true)
          res.stub(:headers).and_return({"account_email" => email})
          HTTParty.stub(:put).and_return(res)
          expect(subject.update).to eq(email)
        end

        context "for access requested" do
          before(:each) {
            AccessRequest.stub(:find_by).and_return(acess_request)
          }
          context "when a access request exists" do
            let(:acess_request) {
              double('ar', username: "hey@im.ok",
                           first_name: "First",
                           last_name: "Last",
                           cas_user_id: '1')
                      }
            it "find the access request via email and Creates the user" do
              expect(AccessRequest).to receive(:find_by).with(username: "hey@im.ok")
              expect(User).to receive(:create).with(
                username: acess_request.username,
                first: acess_request.first_name,
                last: acess_request.last_name,
                cas_user_id: acess_request.cas_user_id
              )
              inv_password_form.update
            end
          end
          context "when a access request DOES NOT exists" do
            let(:acess_request) { nil }
            it "finds a nil AccessRequest and does not create a user" do
              expect(AccessRequest).to receive(:find_by).with(username: "hey@im.ok")
              expect(User).to_not receive(:create)
              inv_password_form.update
            end
          end
        end
      end

      context "when update is unsuccessful" do
        context "given there are error messages" do
          it "adds the response errors to the forms errors" do
            InvitationPasswordForm.any_instance.stub(:valid?).and_return(true)
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
          InvitationPasswordForm.any_instance.stub(:valid?).and_return(true)
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
        InvitationPasswordForm.any_instance.stub(:valid?).and_return(false)
        expect(subject.update).to be_false
      end
    end
  end
end
