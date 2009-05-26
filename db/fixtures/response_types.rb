ResponseType.seed(:title, :input_type) do |s|  
  s.title = "Standard Text Field"
  s.input_type = "text_field"   
  s.options = {}
end

ResponseType.seed(:title, :input_type) do |s|  
  s.title = "Standard Text Area"
  s.input_type = "text_area"   
  s.options = {}
end

ResponseType.seed(:title, :input_type) do |s|  
  s.title = "Large Text Area"   
  s.input_type = "text_area"
  s.options = { :cols => 20, :rows => 80 }
end

ResponseType.seed(:title, :input_type) do |s|  
  s.title = "Select Tag"
  s.input_type = "select"   
  s.options = {}
end