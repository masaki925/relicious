FB_PERMISSIONS = 'email,
                  user_birthday,
                  user_likes,
                  user_education_history,
                  user_location,
                  user_work_history,
                  read_stream,
                  publish_stream'

MEETUP_STATUS_INVITED  = 0
MEETUP_STATUS_ATTEND   = 1
MEETUP_STATUS_DECLINED = 2

NATIONALITIES = YAML.load_file("#{Rails.root}/config/nationalities.yml")

