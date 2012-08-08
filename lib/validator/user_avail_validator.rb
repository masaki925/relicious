class UserAvailValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << I18n.t("errors.validates.presence_user_avails") if record.user_avails.blank?
  end
end
