# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Reps::Application.initialize!
Time::DATE_FORMATS[:my_datetime] = "%Y.%m.%d at %l %P"
