require 'spec_helper'

describe MeetupCommentsController do

  # This should return the minimal set of attributes required to create a valid
  # MeetupComment. As you add validations to MeetupComment, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MeetupCommentsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before { @meetup = FactoryGirl.create(:meetup) }

  context "when user is NOT logged in" do
    describe "POST create" do
      it "reject any operations" do
        post :create, { meetup_id: @meetup.id }, {}
        response.should redirect_to(root_path)
      end
    end
  end

  context "when user logged in" do
    before { @user = FactoryGirl.create(:user) }

    context "when user is NOT a member of the meetup" do
      describe "POST create" do
        it "reject any operations" do
          post :create, { meetup_id: @meetup.id }, { user_id: @user.id }
          response.should redirect_to(root_path)
        end
      end
    end

    context "when user is a member of the meetup" do
      before { @user_meetup_permission = FactoryGirl.create(:user_meetup_permission, user: @user, meetup: @meetup) }

      context "when status is NOT MEETUP_STATUS_ATTEND" do
        it "reject any operations"
      end

      context "when status is MEETUP_STATUS_ATTEND" do
        before { @user_meetup_permission.status = MEETUP_STATUS_ATTEND }

        describe "POST create" do
          describe "with valid params" do
            it "creates a new MeetupComment" do
              expect {
                post :create, {meetup_comment: FactoryGirl.attributes_for(:meetup_comment), meetup_id: @meetup.id}, {user_id: @user.id}
              }.to change(MeetupComment, :count).by(1)
            end

            it "assigns a newly created meetup_comment as @meetup_comment" do
              post :create, {meetup_comment: FactoryGirl.attributes_for(:meetup_comment), meetup_id: @meetup.id}, {user_id: @user.id}
              assigns(:meetup_comment).should be_a(MeetupComment)
              assigns(:meetup_comment).should be_persisted
            end

            it "redirects to the related meetup detail page" do
              post :create, {meetup_comment: FactoryGirl.attributes_for(:meetup_comment), meetup_id: @meetup.id}, {user_id: @user.id}
              response.should redirect_to(meetup_path(@meetup))
            end
          end

          describe "with invalid params" do
            before  { post :create, { meetup_id: @meetup.id }, {user_id: @user.id } }

            specify { response.should redirect_to(meetup_path(@meetup)) }
          end
        end

        describe "PUT update" do
          before { @meetup_comment = FactoryGirl.create(:meetup_comment, meetup_id: @meetup.id, user_id: @user.id) }

          describe "with valid params" do
            it "updates the requested meetup_comment" do
              # Assuming there are no other meetup_comments in the database, this
              # specifies that the MeetupComment created on the previous line
              # receives the :update_attributes message with whatever params are
              # submitted in the request.
              MeetupComment.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
              put :update, {:meetup_id => @meetup.id, :id => @meetup_comment.id, :meetup_comment => {'these' => 'params'}}, {:user_id => @user.id}
            end

            it "assigns the requested meetup_comment as @meetup_comment" do
              put :update, {:meetup_id => @meetup.id, :id => @meetup_comment.id, :meetup_comment => valid_attributes}, {:user_id => @user.id}
              assigns(:meetup_comment).should eq(@meetup_comment)
            end

            it "redirects to the related meetup detail page" do
              #put :update, {:meetup_id => @meetup.id, :id => @meetup_comment.id, :meetup_comment => valid_attributes}, {:user_id => @user.id}
              put :update, {:meetup_id => @meetup.id, :id => @meetup_comment.id, :meetup_comment => valid_attributes}, {:user_id => @user.id}
              response.should redirect_to(meetup_path(@meetup_comment.meetup))
            end
          end

          describe "with invalid params" do
            it "assigns the meetup_comment as @meetup_comment" do
              # Trigger the behavior that occurs when invalid params are submitted
              MeetupComment.any_instance.stub(:save).and_return(false)
              put :update, {:meetup_id => @meetup.id, :id => @meetup_comment.id, :meetup_comment => {}}, {:user_id => @user.id}
              assigns(:meetup_comment).should eq(@meetup_comment)
            end

            it "re-renders the 'edit' template" do
              # Trigger the behavior that occurs when invalid params are submitted
              MeetupComment.any_instance.stub(:save).and_return(false)
              put :update, {meetup_id: @meetup.id, id: @meetup_comment.id, meetup_comment: {}}, {user_id: @user.id}
              response.should redirect_to(meetup_path(@meetup_comment.meetup))
            end
          end
        end

        describe "DELETE destroy" do
          before { @meetup_comment = FactoryGirl.create(:meetup_comment, meetup_id: @meetup.id, user_id: @user.id) }

          context "when the comment is created by OTHER user" do
            before { @other_user = FactoryGirl.create(:user) }

            it "rejected" do
              expect {
                delete :destroy, {meetup_id: @meetup.id, id: @meetup_comment.id}, {user_id: @other_user.id}
              }.to change(MeetupComment, :count).by(0)
            end

            it "redirects to the meetup detail page" do
              delete :destroy, {meetup_id: @meetup.id, id: @meetup_comment.id}, {user_id: @other_user.id}
              response.should redirect_to(root_path)
            end
          end

          context "when the comment is created by user own" do
            it "destroys the requested meetup_comment" do
              expect {
                delete :destroy, {meetup_id: @meetup.id, id: @meetup_comment.id}, {user_id: @user.id}
              }.to change(MeetupComment, :count).by(-1)
            end

            it "redirects to the meetup detail page" do
              delete :destroy, {meetup_id: @meetup.id, id: @meetup_comment.id}, {user_id: @user.id}
              response.should redirect_to(meetup_path(@meetup_comment.meetup))
            end
          end
        end
      end
    end
  end
end
