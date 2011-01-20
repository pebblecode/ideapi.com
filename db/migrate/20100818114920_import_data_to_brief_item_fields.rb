class ImportDataToDocumentItemFields < ActiveRecord::Migration
  def self.up
    DocumentItem.all.each do |document_item|
      question = TemplateQuestion.find(:first, :conditions => {:id => document_item.template_question_id})
      if question.present?
        document_item.help_message = question.help_message if question.help_message.present?
        document_item.optional = question.optional if question.optional.present?
        document_item.save
      end
    end
  end

  def self.down
  end
end