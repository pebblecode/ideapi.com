%w(jason alex seb toby fergus).each do |peep|
  User.seed(:login, :email) do |s|
    s.login = peep
    s.email = "#{peep}@ideapi.com"
    s.password = "password"
    s.password_confirmation = "password"
    s.invite_count = 9999
  end
end