# Rapns configuration. Options set here are overridden by command-line options.

Rapns.configure do |config|

  # Run in the foreground?
  # config.foreground = false

  # Frequency in seconds to check for new notifications.
  # config.push_poll = 2

  # Frequency in seconds to check for feedback
  # config.feedback_poll = 60

  # Enable/Disable error notifications via Airbrake.
  # config.airbrake_notify = true

  # Disable APNs error checking after notification delivery.
  # config.check_for_errors = true

  # ActiveRecord notifications batch size.
  # config.batch_size = 5000

  # Path to write PID file. Relative to Rails root unless absolute.
  # config.pid_file = '/path/to/rapns.pid'

  # Define a block that will be called with a Rapns::Apns::Feedback instance
  # when feedback is received from the APNs that a notification has
  # failed to be delivered. Further notifications should not be sent to the device.
  #
  # Example:
  # config.on_apns_feedback do |feedback|
  #   device = Device.find_by_device_token(feedback.device_token)
  #   if device
  #     device.active = false
  #     device.save!
  #   end
  # end


  # using redis blpop to fetch notification ids into delivery quueue.
  # set the redis_backend value when enable blpop.
  # config.blpop = true
  #
  # config.redis_backend = 'redis://127.0.0.1:6379/11'
  #
  # custom the list name using by rapns-daemon
  # config.blpop_key = 'rapns_blpop_list_ids'

end
