require 'spec_helper'

describe MeetupsController do

  # This should return the minimal set of attributes required to create a valid
  # Meetup. As you add validations to Meetup, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MeetupsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  context "when user is NOT logged in" do
    it "reject any operations"
  end

  before do
    @area = FactoryGirl.create(:area)
  end

  context "when user logged in" do
    before { @user = FactoryGirl.create(:user) }

    context "when the meetup is public" do
      before do
        @meetup          = FactoryGirl.create( :meetup, public: true, fixed: true )
        @meetup_exceptme = FactoryGirl.create( :meetup, public: true, fixed: true )
        @permission      = FactoryGirl.create( :user_meetup_permission, :user_id => @meetup_exceptme.user_id, :meetup_id => @meetup_exceptme.id )
      end

      describe "GET index" do
        before { get :index, {}, { :user_id => @user.id } }

        specify { assigns(:meetups).should eq([@meetup_exceptme]) }
        specify { response.should be_success }
      end

      describe "POST invite" do
        before do
          UserMailer.any_instance.stub(:deliver).and_return(true)
        end

        describe "with valid params" do
          before { @invited_user = FactoryGirl.create(:user) }

          it "creates a new Permission" do
            expect {
              post :invite, { :id => @meetup.id, :invited_user_id => @invited_user.id  }, {:user_id => @user.id}
            }.to change(UserMeetupPermission, :count).by(1)
          end

          it "send mail to invited member" do
            pending "check mail send log from RDB or somewhere"
          end

          it "redirects to the meetup" do
            post :invite, { :id => @meetup.id, :invited_user_id => @invited_user.id }, {:user_id => @user.id}
            response.should redirect_to( meetup_path(@meetup) )
          end
        end

        describe "with invalid params" do
          before { FactoryGirl.create(:user_meetup_permission, user_id: @user.id, meetup_id: @meetup.id) }

          it "reject invitee is already invited" do
            expect {
              post :invite, { :id => @meetup.id, :invited_user_id => @user.id }, {:user_id => @user.id}
            }.to change(UserMeetupPermission, :count).by(0)
          end

          it "redirects to the meetup" do
            post :invite, { :id => @meetup.id, :invited_user_id => nil }, {:user_id => @user.id}
            response.should redirect_to( meetup_path(@meetup) )
          end
        end
      end

      describe "GET show" do
        before do
          @other_user = FactoryGirl.create(:user)

          get :show, {:id => @meetup.id}, { :user_id => @user.id }
        end

        specify { assigns(:meetup).should eq(@meetup) }
      end

      describe "GET new" do
        before { get :new, {}, { :user_id => @user.id } }

        specify { assigns(:meetup).should be_a_new(Meetup) }
      end

      describe "GET edit" do
        before do
          @meetup.user_id = @user.id
          get :edit, {:id => @meetup.id }, { :user_id => @user.id }
        end

        specify { assigns(:meetup).should eq(@meetup) }
      end

      describe "GET join" do
        before do
          @other_user = FactoryGirl.create(:user)
        end

        it "add meetup to user.meetups" do
          expect {
            get :join, {:id => @meetup.id }, { :user_id => @other_user.id }
          }.to change(@other_user.meetups, :count).by(1)
        end

        it "add user to meetup.users" do
          expect {
            get :join, {:id => @meetup.id }, { :user_id => @other_user.id }
          }.to change(@meetup.users, :count).by(1)
        end

        it "redirect to meetup detail page" do
          redirect_to ( meetup_path(@meetup) )
        end
      end

      describe "POST create" do
        before do
          UserMailer.any_instance.stub( :deliver ).and_return( true )
        end

        context "with member" do
          before { @invited_user = FactoryGirl.create( :user ) }

          describe "with valid params" do
            it "creates a new Meetup" do
              expect {
                post :create, { :meetup         => FactoryGirl.attributes_for( :meetup_without_mass_assign, area_id: @area.id ),
                                :meetup_comment => FactoryGirl.attributes_for( :meetup_comment ) },
                              { :user_id => @user.id }
              }.to change( Meetup, :count ).by( 1 )
            end

            it "add meetup to user.meetups" do
              expect {
                post :create, { meetup: FactoryGirl.attributes_for( :meetup_without_mass_assign, area_id: @area.id ),
                                meetup_comment: FactoryGirl.attributes_for( :meetup_comment ) },
                              { user_id: @user.id }
              }.to change( @user.meetups, :count ).by( 1 )
            end

            it "set user_meetup_permissions status to attend for user" do
              post :create, { meetup: FactoryGirl.attributes_for( :meetup_without_mass_assign, area_id: @area.id ),
                              meetup_comment: FactoryGirl.attributes_for( :meetup_comment ) },
                            { user_id: @user.id }
              assigns( :my_meetup_permission ).should be_a( UserMeetupPermission )
              assigns( :my_meetup_permission ).should be_persisted
              assigns( :my_meetup_permission ).status.should eq( MEETUP_STATUS_ATTEND )
            end

            it "set user_meetup_permissions status to invited for invitee" do
              post :create, { meetup: FactoryGirl.attributes_for(:meetup_without_mass_assign, area_id: @area.id),
                              member: @invited_user.id,
                              meetup_comment: FactoryGirl.attributes_for( :meetup_comment ) },
                            { user_id: @user.id }
              assigns( :invitee_meetup_permission ).should be_a( UserMeetupPermission )
              assigns( :invitee_meetup_permission ).should be_persisted
              assigns( :invitee_meetup_permission ).status.should eq( MEETUP_STATUS_INVITED )
            end

            it "send mail to invited member" do
              pending "check mail send log from RDB or somewhere"
            end

            it "assigns a newly created meetup as @meetup" do
              post :create, { meetup: FactoryGirl.attributes_for( :meetup_without_mass_assign, area_id: @area.id ),
                              meetup_comment: FactoryGirl.attributes_for( :meetup_comment ) },
                            { :user_id => @user.id }
              assigns( :meetup ).should be_a( Meetup )
              assigns( :meetup ).should be_persisted
            end

            it "redirects to the created meetup" do
              post :create, { meetup: FactoryGirl.attributes_for( :meetup_without_mass_assign, area_id: @area.id ),
                              meetup_comment: FactoryGirl.attributes_for( :meetup_comment ) },
                            { :user_id => @user.id }
              response.should redirect_to( Meetup.last )
            end
          end

          describe "with invalid params" do
            it "assigns a newly created but unsaved meetup as @meetup" do
              # Trigger the behavior that occurs when invalid params are submitted
              Meetup.any_instance.stub(:save).and_return(false)
              post :create, {:meetup => {}}, {:user_id => @user.id}
              assigns(:meetup).should be_a_new(Meetup)
            end

            it "re-renders the 'new' template" do
              # Trigger the behavior that occurs when invalid params are submitted
              Meetup.any_instance.stub(:save).and_return(false)
              post :create, {:meetup => {}}, {:user_id => @user.id}
              response.should render_template("new")
            end
          end
        end
      end

      describe "PUT update" do
        context "when user is NOT attending the meetup" do
          before { @new_user = FactoryGirl.create(:user) }

          it "deny update the meetup" do
            put :update, { :id => @meetup.id, :meetup => { 'these' => 'params' } }, { :user_id => @new_user.id }
            response.should redirect_to( @meetup )
          end
        end

        context "when user is attending the meetup" do
          before do
            @new_user = FactoryGirl.create( :user )
            FactoryGirl.create( :user_meetup_permission, :user_id => @new_user.id, :meetup_id => @meetup.id, :status => MEETUP_STATUS_ATTEND )
          end

          describe "with valid params" do
            it "updates the requested meetup" do
              # Assuming there are no other meetups in the database, this
              # specifies that the Meetup created on the previous line
              # receives the :update_attributes message with whatever params are
              # submitted in the request.
              Meetup.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
              put :update, { :id => @meetup.id, :meetup => {'these' => 'params'}}, {:user_id => @new_user.id }
            end
            
            it "assigns the requested meetup as @meetup" do
              put :update, { :id => @meetup.id, :meetup => valid_attributes}, {:user_id => @new_user.id }
              assigns(:meetup).should eq(@meetup)
            end
            
            it "redirects to the meetup" do
              put :update, { :id => @meetup.id, :meetup => valid_attributes}, {:user_id => @new_user.id }
              response.should redirect_to(@meetup)
            end
          end
          
          describe "with invalid params" do
            it "assigns the meetup as @meetup" do
              # Trigger the behavior that occurs when invalid params are submitted
              Meetup.any_instance.stub(:save).and_return(false)
              put :update, {:id => @meetup.id, :meetup => {}}, {:user_id => @new_user.id}
              assigns(:meetup).should eq(@meetup)
            end
          
            it "re-renders the 'edit' template" do
              # Trigger the behavior that occurs when invalid params are submitted
              Meetup.any_instance.stub(:save).and_return(false)
              put :update, {:id => @meetup.id, :meetup => {}}, {:user_id => @new_user.id}
              response.should render_template("edit")
            end
          end
        end
      end

      describe "DELETE destroy" do
        context "when the meetup is created by OTHER user" do
          before { @other_user = FactoryGirl.create(:user) }

          it "rejected" do
            expect {
              delete :destroy, {:id => @meetup.id}, {:user_id => @other_user.id}
            }.to change(Meetup, :count).by(0)
          end

          it "redirects to the meetups list" do
            delete :destroy, {:id => @meetup.id}, {:user_id => @other_user.id}
            response.should redirect_to(root_path)
          end
        end

        context "when the meetup is created by user own" do
          before do
            @own_meetup = FactoryGirl.create(:meetup, user_id: @user.id)
            FactoryGirl.create(:user_meetup_permission, user_id: @user.id, meetup_id: @own_meetup.id, status: MEETUP_STATUS_ATTEND)
          end
          it "destroys the requested meetup" do
            expect {
              delete :destroy, {:id => @own_meetup.id}, {:user_id => @user.id}
            }.to change(Meetup, :count).by(-1)
          end

          it "redirects to the meetups list" do
            delete :destroy, {:id => @own_meetup.id}, {:user_id => @user.id}
            response.should redirect_to(root_path)
          end
        end
      end
    end

    context "when the meetup is private" do
      before { @meetup = FactoryGirl.create(:meetup, public: false) }

      context "when user is NOT a member of the meetups" do
        describe "GET show" do
          before do
            get :show, {:id => @meetup.id}, { :user_id => @user.id }
          end

          specify { response.should_not be_success }
        end
      end

      context "when user is a member of the meetups" do
        before do
          @user_meetup_permission = FactoryGirl.create(:user_meetup_permission, user: @user, meetup: @meetup, status: MEETUP_STATUS_INVITED)
        end

        describe "POST status" do
          it "change user status" do
            post :status, {:id => @meetup.id, meetup_status_select: MEETUP_STATUS_ATTEND }, { :user_id => @user.id }
            assigns(:meetup_permission).status.should_not eq(MEETUP_STATUS_INVITED)
          end

          it "redirect to meetup detail page" do
            post :status, {:id => @meetup.id }, { :user_id => @user.id }
            redirect_to ( meetup_path(@meetup) )
          end
        end

        describe "GET show" do
          before do
            get :show, {:id => @meetup.id}, { :user_id => @user.id }
          end

          specify { assigns(:meetup).should eq(@meetup) }
          specify { response.should be_success }
        end
      end
    end
  end
end
