Given /^I visit a page on the root domain$/ do
  fail unless host = ENV['SKEWER_HOST']
  @page = `curl -s "http://#{host}/"`
end


Then /^I should see '(.*)'$/ do |arg|
  @page.should match(/#{arg}/)
end
