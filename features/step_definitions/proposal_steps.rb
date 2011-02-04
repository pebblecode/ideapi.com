Given /^I have ideas called (.+)$/ do |ideas|
  ideas.split(', ').each do |idea|
    @published = Proposal.make(:title => idea)
  end
end