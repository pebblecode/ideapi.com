Author.seed(:login, :email) do |s|  
  s.login = "jason"   
  s.email = "jase@jaseandtonic.com"
  s.password = "testing"
  s.password_confirmation = "testing"   
end

Creative.seed(:login, :email) do |s|
  s.login = "creative"   
  s.email = "creative@jaseandtonic.com"
  s.password = "testing"
  s.password_confirmation = "testing"
end