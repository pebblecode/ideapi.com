BriefTemplate.seed(:title) do |s|
  s.title = "Default"
  s.brief_config_id = BriefConfig.current.id
end