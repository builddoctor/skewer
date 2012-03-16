Given /^I run something arbitrary$/ do
  true
end

Then /^it should fail$/ do
  s = true
  s.should == false
end
