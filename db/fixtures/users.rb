User.seed(:login, :email) do |s|  
  s.login = "jason"   
  s.email = "jase@jaseandtonic.com"
  s.password = "testing"
  s.password_confirmation = "testing"   
end