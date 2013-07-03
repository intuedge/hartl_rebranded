require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'Starter App') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
    it { should_not have_selector 'h2', text: 'sample app' }
    it { should have_selector 'h2', text: 'starter app' }
    it { should have_selector 'h2', text: 'extending' }
    it { should have_selector 'footer', text: 'Extending' }
    it { should_not have_selector 'footer', text: 'News' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
    it { should have_selector('p',     text: 'starter') }
    it { should have_selector('p',     text: 'original sample') }
    it { should have_selector('p',     text: 'no specific help yet') }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title', text: full_title('About Us')) }
    it { should have_selector('p',     text: 'starter') }
    it { should have_selector('p',     text: 'original sample') }
    it { should have_selector('a',     text: 'RailsBridge.org') }
    it { should have_selector('a',     text: 'license information') }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
    it { should have_selector('p',     text: 'starter') }
    it { should have_selector('p',     text: 'original sample') }
    it { should_not have_selector('p', text: 'starter.app [at] intuedge.net') }
    it { should have_selector('p',     text: 'intuedge.starter.app [at] gmail.com') }
    it { should have_selector('p',     text: 'no formal contact yet') }
	end

  describe "License page" do
    before { visit license_path }

    it { should have_selector('h1',    text: 'License Information') }
    it { should have_selector('title', text: full_title('Licensing')) }
    it { should have_selector('p',     text: 'starter') }
    it { should have_selector('p',     text: 'original sample') }
    it { should have_selector('p',     text: 'MIT License') }
    it { should have_selector('p',     text: 'Beerware License') }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "license information"
    page.should have_selector 'title', text: full_title('Licensing')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "starter app"
    page.should have_selector 'h1', text: 'Starter App'
  end
end