template = TemplateDocument.seed(:title) do |s|
  s.title = "Default"
  s.default = true
end

if template

  %w(Background Problem Task Other).each do |section_title|
    TemplateSection.seed(:title) do |s|  
      s.title = section_title
    end
  end
  
  if section = TemplateSection.find_by_title("Background")

    #this is a simple array [question_title, question_help_text]

    questions = [
      ["Brand", "What is the brand? Its heritage? Its popularity? Give a short description of the brand and any information that may be useful.", false],
      ["Product", "What is the product? How do people use it? Is it new? Established? What makes it different / better?", false],
      ["Competitive Context", "Who are the competition? What are they like? What do they say? What are they likely to do next? How do you compare?", true]
    ]

    questions.each do |question|
      TemplateQuestion.seed(:body) do |s|
        s.body = question[0]
        s.help_message = question[1]
        s.template_section = section
        s.optional = question[2]
      end
    end
  end

  if section = TemplateSection.find_by_title("Problem")
    questions = [
      ["Problem / Opportunity", "What can communications do? What do they need to solve?", false]
    ]

    questions.each do |question|
      TemplateQuestion.seed(:body) do |s|
        s.body = question[0]
        s.help_message = question[1]
        s.template_section = section
        s.optional = question[2]
      end
    end
  end

  if section = TemplateSection.find_by_title("Task")
    questions = [
      ["Mandatories", "e.g. Pack shots, logos, brand guidelines.", false],
      ["Target Audience", "Who do you want to reach? Paint a picture of the target?", true],
      ["Media", "Digital? Traditional? Ambient? Are the specifications known?", true]
    ]

    questions.each do |question|
      TemplateQuestion.seed(:body) do |s|
        s.body = question[0]
        s.help_message = question[1]
        s.template_section = section
        s.optional = question[2]
      end
    end
  end
  
  if section = TemplateSection.find_by_title("Other")
    questions = [
      ["Other Essential Information", "The kitchen sink.", true]
    ]

    questions.each do |question|
      TemplateQuestion.seed(:body) do |s|
        s.body = question[0]
        s.help_message = question[1]
        s.template_section = section
        s.optional = question[2]
      end
    end
  end

  template.template_questions << TemplateQuestion.all 

end
