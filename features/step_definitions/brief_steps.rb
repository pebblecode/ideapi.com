Given /^"([^"]*)" is marked as "([^"]*)"$/ do |brief, state|
  b = Brief.find_by_title(brief)
  b.state = state
  b.save
end


