if section = BriefSection.find_by_title("What?")
  
  #this is a simple array [question_title, question_help_text]
  
  questions = [
    ["The Brand", "Manufacturer? Service? Retail? Corporate? Media? Ingredient? Fashion?", false],
    ["The Product", "", false],
    ["What does it stand for or promise?", "", true],
    ["What is the competitive context?", "What is the context now? In the future? Are other brands fulfilling similar role? Are there alternatives?", true]
  ]
  
  questions.each do |question|
    BriefQuestion.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
      s.assign_brief_section = section
      s.optional = question[2]
    end
  end
end

if section = BriefSection.find_by_title("Why?")
  questions = [
    ["What is the problem / opportunity", "To Inform? Explain/Introduce/Provoke/Reassure/Challenge? Persuade/Seduce? Remind? Magnify?", false],
    ["Why are we doing this?", "this? To Grow/Steal/Consolidate market share?  To attack/defend? To Amuse or highlight?", false]
  ]
  
  questions.each do |question|
    BriefQuestion.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
      s.assign_brief_section = section
      s.optional = question[2]
    end
  end
end

if section = BriefSection.find_by_title("Who?")
  questions = [
    ["Who or what are they?", "", false],
    ["How do they feel about life?", "", true],
    ["What competes for their attention?", "", true],
    ["How do they relate to the sector?", "", true],
    ["How do they relate to the brand?", "", true]
  ]
  
  questions.each do |question|
    BriefQuestion.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
      s.assign_brief_section = section
      s.optional = question[2]
    end
  end
end

if section = BriefSection.find_by_title("How?")
  questions = [
    ["What is the single thing you want to say?", "", false],
    ["Why is this believable?", "", true],
    ["Why should people care?", "", true],
    ["How do we want the consumer to feel/think/behave", "", false],
    ["What is the tone of voice?", "", true],
    ["What are the mandatories?", "", true]
  ]
  
  questions.each do |question|
    BriefQuestion.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
      s.assign_brief_section = section
      s.optional = question[2]
    end
  end
end

if section = BriefSection.find_by_title("Where?")
  questions = [
    ["What is the media?", "", false],
    ["What is the media context?", "", true],
    ["Targeting", "", false]
  ]
  
  questions.each do |question|
    BriefQuestion.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
      s.assign_brief_section = section
      s.optional = question[2]
    end
  end
end