require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

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

  context "when user logged in" do
    before do
      @meetup = FactoryGirl.create(:meetup)
      @user = @meetup.user
      @area = @meetup.area
    end

    describe "GET index" do
      before { get :index, {}, { :user_id => @user.id } }

      specify { assigns(:meetups).should eq([@meetup]) }
      specify { response.should be_success }
    end

    describe "GET show" do
      before { get :show, {:id => @meetup.id}, { :user_id => @user.id } }

      specify { assigns(:meetup).should eq(@meetup) }
    end

    describe "GET new" do
      before { get :new, {}, { :user_id => @user.id } }

      specify { assigns(:meetup).should be_a_new(Meetup) }
    end

    describe "GET edit" do
      before { get :edit, {:id => @meetup.id }, { :user_id => @user.id } }

      specify { assigns(:meetup).should eq(@meetup) }
    end

    describe "GET join" do
      before do
        @other_user = FactoryGirl.create(:user)
        @other_meetup = FactoryGirl.create(:meetup, user: @other_user)
      end

      it "add meetup to user.meetups" do
        expect {
          get :join, {:id => @other_meetup.id }, { :user_id => @user.id }
        }.to change(@user.meetups, :count).by(1)
      end

      it "add user to meetup.users" do
        expect {
          get :join, {:id => @other_meetup.id }, { :user_id => @user.id }
        }.to change(@other_meetup.users, :count).by(1)
      end

      it "redirect to meetup detail page" do
        redirect_to ( meetup_path(@other_meetup) )
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Meetup" do
          expect {
            post :create, { :meetup => FactoryGirl.attributes_for(:meetup, area_id: @area.id) }, {:user_id => @user.id}
          }.to change(Meetup, :count).by(1)
        end

        it "add meetup to user.meetups" do
          expect {
            post :create, { :meetup => FactoryGirl.attributes_for(:meetup, area_id: @area.id) }, {:user_id => @user.id}
          }.to change(@user.meetups, :count).by(1)
        end

        it "assigns a newly created meetup as @meetup" do
          post :create, {:meetup => FactoryGirl.attributes_for(:meetup, area_id: @area.id)}, {:user_id => @user.id}
          assigns(:meetup).should be_a(Meetup)
          assigns(:meetup).should be_persisted
        end

        it "redirects to the created meetup" do
          post :create, {:meetup => FactoryGirl.attributes_for(:meetup, area_id: @area.id)}, {:user_id => @user.id}
          response.should redirect_to(Meetup.last)
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

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested meetup" do
          # Assuming there are no other meetups in the database, this
          # specifies that the Meetup created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Meetup.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => @meetup.id, :meetup => {'these' => 'params'}}, {:user_id => @user.id}
        end

        it "assigns the requested meetup as @meetup" do
          put :update, {:id => @meetup.id, :meetup => valid_attributes}, {:user_id => @user.id}
          assigns(:meetup).should eq(@meetup)
        end

        it "redirects to the meetup" do
          put :update, {:id => @meetup.id, :meetup => valid_attributes}, {:user_id => @user.id}
          response.should redirect_to(@meetup)
        end
      end

      describe "with invalid params" do
        it "assigns the meetup as @meetup" do
          # Trigger the behavior that occurs when invalid params are submitted
          Meetup.any_instance.stub(:save).and_return(false)
          put :update, {:id => @meetup.id, :meetup => {}}, {:user_id => @user.id}
          assigns(:meetup).should eq(@meetup)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Meetup.any_instance.stub(:save).and_return(false)
          put :update, {:id => @meetup.id, :meetup => {}}, {:user_id => @user.id}
          response.should render_template("edit")
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
          response.should redirect_to(meetups_url)
        end
      end

      context "when the meetup is created by user own" do
        it "destroys the requested meetup" do
          expect {
            delete :destroy, {:id => @meetup.id}, {:user_id => @user.id}
          }.to change(Meetup, :count).by(-1)
        end
    
        it "redirects to the meetups list" do
          delete :destroy, {:id => @meetup.id}, {:user_id => @user.id}
          response.should redirect_to(meetups_url)
        end
      end
    end
  end
end
