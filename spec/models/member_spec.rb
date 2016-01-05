require "rails_helper"

RSpec.describe Member, type: :model do
  before(:each) do
    @phone = '13911320927'
    @first_name ='皓'
    @last_name ='王'
    @club = Club.create!(name: '北京珀斐高尔夫俱乐部', code: 'perfect')
  end

  describe 'search member' do
    context 'with phone' do
      it 'should work' do
        Member.create_visitor(club: @club, phone: @phone)
        member = @club.members.search(phone: @phone)
        expect(member.club.name).to eq(@club.name)
        expect(member.user.phone).to eq(@phone)
      end
    end
  end

  describe 'create visitor' do
    context 'without phone' do
      it 'should work' do
        member = Member.create_visitor(club: @club)
        expect(member.club.name).to eq(@club.name)
        expect(member.user.phone).to eq(nil)
      end
    end
    context 'with phone' do
      it 'should work' do
        member = Member.create_visitor(club: @club, phone: @phone)
        expect(member.club.name).to eq(@club.name)
        expect(member.user.phone).to eq(@phone)
      end
    end
    context 'with phone and name' do
      it 'should work' do
        member = Member.create_visitor(club: @club, phone: @phone, first_name: @first_name, last_name: @last_name)
        expect(member.club.name).to eq(@club.name)
        expect(member.user.phone).to eq(@phone)
        expect(member.user.first_name).to eq(@first_name)
        expect(member.user.last_name).to eq(@last_name)
      end
    end
  end

  describe 'create regular' do
    context 'without phone' do
      it 'should work' do
        member = Member.create_regular(club: @club)
        expect(member.club.name).to eq(@club.name)
        expect(member.user.phone).to eq(nil)
      end
    end
    context 'with phone' do
      it 'should work' do
        member = Member.create_regular(club: @club, phone: @phone)
        expect(member.club.name).to eq(@club.name)
        expect(member.user.phone).to eq(@phone)
      end
    end
    context 'with phone and name' do
      it 'should work' do
        member = Member.create_regular(club: @club, phone: @phone, first_name: @first_name, last_name: @last_name)
        expect(member.club.name).to eq(@club.name)
        expect(member.user.phone).to eq(@phone)
        expect(member.user.first_name).to eq(@first_name)
        expect(member.user.last_name).to eq(@last_name)
      end
    end
  end
end