class UserLanguageValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << I18n.t("errors.validates.presence_language") if record.user_languages.blank?
  end
end
