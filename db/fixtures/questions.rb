if section = Section.find_by_title("What?")
  
  #this is a simple array [question_title, question_help_text]
  
  questions = [
    ["The Brand", "Manufacturer? Service? Retail? Corporate? Media? Ingredient? Fashion?"],
    ["The Product", ""],
    ["What does it stand for or promise?", ""],
    ["What is the competitive context?", "What is the context now? In the future? Are other brands fulfilling similar role? Are there alternatives?"]
  ]
  
  questions.each do |question|
    Question.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
    end
  end
end

if section = Section.find_by_title("Why?")
  questions = [
    ["What is the problem / opportunity", "To Inform? Explain/Introduce/Provoke/Reassure/Challenge? Persuade/Seduce? Remind? Magnify?"],
    ["Why are we doing this?", "this? To Grow/Steal/Consolidate market share?  To attack/defend? To Amuse or highlight?"]
  ]
  
  questions.each do |question|
    Question.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
    end
  end
end

if section = Section.find_by_title("Who?")
  questions = [
    ["Who or what are they?", ""],
    ["How do they feel about life?", ""],
    ["What competes for their attention?", ""],
    ["How do they relate to the sector?", ""],
    ["How do they relate to the brand?", ""]
  ]
  
  questions.each do |question|
    Question.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
    end
  end
end

if section = Section.find_by_title("How?")
  questions = [
    ["What is the single thing you want to say?", ""],
    ["Why is this believable?", ""],
    ["Why should people care?", ""],
    ["How do we want the consumer to feel/think/behave", ""],
    ["What is the tone of voice?", ""],
    ["What are the mandatories?", ""]
  ]
  
  questions.each do |question|
    Question.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
    end
  end
end

if section = Section.find_by_title("Where?")
  questions = [
    ["What is the media?", ""],
    ["What is the media context?", ""],
    ["Targeting", ""]
  ]
  
  questions.each do |question|
    Question.seed(:title) do |s|
      s.title = question[0]
      s.help_text = question[1]
    end
  end
end