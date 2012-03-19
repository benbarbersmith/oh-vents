require 'spec_helper'

def sign_in
  visit root_url
  click_link "Sign in"
end

def sign_out
  visit root_url
  click_link "Sign out"
end

describe "Users" do

  context "not signed in" do

    it "should login successfully" do
      visit root_path
      click_link "Sign in"
      response.should be_success
    end

    it "should show a success message when logging in" do
      visit root_path
      click_link "Sign in"
      response.should have_selector("div.alert-success", :content => "ve been signed in")
    end

  end

  context "signed in" do

    before(:each) do
      sign_in
    end

    it "should give you the option to sign out" do
      visit root_path
      click_link "Sign out"
      response.should be_success
    end

    it "should show a message when signing out" do
      visit root_path
      click_link "Sign out"
      response.should have_selector("div.alert", :content => "You've been signed out")
    end

  end

end
