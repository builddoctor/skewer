Given /^I visit a page on the root domain$/ do
  fail unless host = ENV['SKEWER_HOST']
  visit("http://#{host}/")
end

Then /^I should see that page in the URL$/ do
  current_path.should == '/about'
end

Then /^I should see '(.*)'$/ do |arg|
  page.has_text? arg
end
