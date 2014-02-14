require 'spec_helper'
describe InvitationForm do
  context "save" do
    it "returns true if invitation request is successful" do
      is  = double('is')
      res = double('r')
      res.stub(:success?).and_return(true)
      is.stub(:invite).and_return(res)
      InvitationService.stub(:new).and_return(is)
      expect(subject.save).to be_true
    end
    context "when request fails" do
      it "returns false if invitation request fails" do
        is  = double('is')
        res = double('r')
        res.stub(:[]).and_return([])
        res.stub(:success?).and_return(false)
        is.stub(:invite).and_return(res)
        InvitationService.stub(:new).and_return(is)
        expect(subject.save).to be_false
      end
      it "adds errors for each error in response" do
        is  = double('is')
        res = double('r')
        res.stub(:success?).and_return(false)
        res.stub(:[]).and_return([])
        is.stub(:invite).and_return(res)
        InvitationService.stub(:new).and_return(is)
        expect(subject.save).to be_false
      end
    end
  end
end
