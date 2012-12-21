module Rapns
  def self.config
    @config ||= Rapns::Configuration.new
  end

  def self.configure
    yield config if block_given?
  end

  def self.redis
    @redis_client ||= Redis.new :url => Rapns.config.redis_backend
  end

  CONFIG_ATTRS = [:foreground, :push_poll, :feedback_poll, :embedded,
    :airbrake_notify, :check_for_errors, :pid_file, :batch_size, :blpop, :redis_backend, :blpop_key]

  class RedisBackendConfigError < ::StandardError; end

  class ConfigurationWithoutDefaults < Struct.new(*CONFIG_ATTRS)
  end

  class Configuration < Struct.new(*CONFIG_ATTRS)
    attr_accessor :apns_feedback_callback

    def initialize
      super

      self.foreground = false
      self.push_poll = 2
      self.feedback_poll = 60
      self.airbrake_notify = true
      self.check_for_errors = true
      self.batch_size = 5000
      self.embedded = false

      self.blpop  = false
      if self.blpop
        self.redis_backend = 'redis://127.0.0.1:6379/0' 
        self.blpop_key = 'rapns_blpop_list_ids'
      end
    end

    def update(other)
      CONFIG_ATTRS.each do |attr|
        other_value = other.send(attr)
        send("#{attr}=", other_value) unless other_value.nil?
      end
    end

    def redis_backend= (redis_url) 
      super

      if using_blpop? && (not redis_format_available?)
        raise RedisBackendConfigError, 'the format of redis url is error'
      end
    end

    def on_apns_feedback(&block)
      self.apns_feedback_callback = block
    end

    def pid_file=(path)
      if path && !Pathname.new(path).absolute?
        super(File.join(Rails.root, path))
      else
        super
      end
    end

    def using_blpop?
      blpop && redis_backend
    end

    protected
    def redis_format_available?
      not(redis_backend !~ /redis:\/\/[\w\.]+(:\d+)?\/\d+/)
    end
  end
end
