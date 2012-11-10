class ApplicationController < ActionController::Base
  protect_from_forgery

  ActionMailer::Base.mail(:from => "be.weinreich@gmail.com", :to => "be.weinreich@gmail.com", :subject => "test", :body => "test").deliver

end
