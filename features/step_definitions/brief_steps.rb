Given /^"([^"]*)" is marked as "([^"]*)"$/ do |brief, state|
  b = Brief.find_by_title(brief)
  b.state = state
  b.save
end

Given /^"([^"]*)" is an author on "([^"]*)"$/ do |author, brief|
  b = Brief.find_by_title(brief)
  u = User.find_by_email(author)
  @account.users << u
  b.users << u
  b.author_id = u.id
  b.save!
end



