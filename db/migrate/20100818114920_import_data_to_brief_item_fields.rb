class ImportDataToBriefItemFields < ActiveRecord::Migration
  def self.up
    BriefItem.all.each do |brief_item|
      question = TemplateQuestion.find(:first, :conditions => {:id => brief_item.template_question_id})
      if question.present?
        brief_item.help_message = question.help_message if question.help_message.present?
        brief_item.optional = question.optional if question.optional.present?
        brief_item.save
      end
    end
  end

  def self.down
  end
end