
Then /^I should see the option to buy the "([^\"]*)" for (\d+)$/ do |name, price|
  nickname = lookup_private_nickname name
  Then "I should see \"#{price}\" within \"#private-#{nickname} .purchase .par\""
  assert_have_selector "#buy-#{nickname}"
end

When /^I choose to buy the "([^\"]*)"$/ do |arg1|
  within "div.private#private-#{lookup_private_nickname(arg1)}" do |scope|
    scope.click_button "Buy"
  end

end

Then /^I should see the option to bid on "([^\"]*)" for (\d+)$/ do |arg1, price|
  nickname = lookup_private_nickname arg1
  assert_have_selector "#bid-#{nickname}"
  assert_equal price, trim_currency_marker(field_value("#private-mid input.bid-value"))
end

When /^I choose to bid "([^\"]*)" on "([^\"]*)"$/ do |arg1, arg2|
  nickname = lookup_private_nickname arg2
  within "div.private#private-#{nickname}" do |scope|
    scope.fill_in "action_data[bid]", :with => arg1
    scope.click_button "Bid"
  end
end
