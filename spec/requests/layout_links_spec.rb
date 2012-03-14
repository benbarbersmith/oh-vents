require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do
    it "should have a Home page at '/'" do
      get '/'
      response.should have_selector('title', :content => "Home")
    end

    it "should have a Contact page at '/'" do
      get '/contact'
      response.should have_selector('title', :content => "Contact")
    end

    it "should have a Help page at '/'" do
      get '/help'
      response.should have_selector('title', :content => "Help")
    end

    it "should have the right links on the layout" do
      visit root_path
      click_link "Help"
      response.should have_selector('title', :content => "Help")
      click_link "Contact"
      response.should have_selector('title', :content => "Contact")
      click_link "Home"
      response.should have_selector('title', :content => "Home")
    end
    
  end
end
