Given /^"([^"]*)" is marked as "([^"]*)"$/ do |document, state|
  b = Document.find_by_title(document)
  b.state = state
  b.save
end

Given /^"([^"]*)" is an author on "([^"]*)"$/ do |author, document|
  b = Document.find_by_title(document)
  u = User.find_by_email(author)
  @account.users << u
  b.users << u
  b.author_id = u.id
  b.save!
end



