all:
	rspec ./spec/controllers/meetup_comments_controller_spec.rb

model:
	rake spec:models

ctl:
	rake spec:controllers

ctl_top:
	rspec spec/controllers/top_controller_spec.rb

