require 'spec_helper'

describe Area do
  before { @area = FactoryGirl.create(:area) }

  describe 'Area#create' do
    context 'without name' do
      before { @area.name = '' }
      specify { @area.should have(1).errors_on(:name) }
    end

    context 'with duplicate registration of name' do
      before { @dup_area = FactoryGirl.build(:area) }
       
      subject  { @dup_area } 
      it { should have(1).errors_on(:name) }
    end
  end
end
