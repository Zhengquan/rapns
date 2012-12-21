module Rapns
  module Daemon
    class Feeder
      extend InterruptibleSleep
      extend DatabaseReconnectable

      def self.start(poll)
        loop do
          enqueue_notifications
          interruptible_sleep poll
          break if @stop
        end unless Rapns.config.using_blpop?

        # using blop to enqueue notifications
        loop do 
          data = Rapns.redis.blpop(Rapns.config.blpop_key, 0)
          lpop_notifications(data[-1])
        end
      end

      def self.stop
        @stop = true
        interrupt_sleep
      end

      protected

      def self.enqueue_notifications
        begin
          with_database_reconnect_and_retry do
            batch_size = Rapns.config.batch_size
            idle = Rapns::Daemon::AppRunner.idle.map(&:app)
            Rapns::Notification.ready_for_delivery.for_apps(idle).limit(batch_size).each do |notification|
              Rapns::Daemon::AppRunner.enqueue(notification)
            end
          end
        rescue StandardError => e
          Rapns::Daemon.logger.error(e)
        end
      end

      def self.lpop_notifications(instance_id)
        with_database_reconnect_and_retry do
          idle = Rapns::Daemon::AppRunner.idle.map(&:app)
          if (notification = Rapns::Notification.for_apps(idle).where('id = ?', instance_id).first)
            Rapns::Daemon::AppRunner.enqueue(notification)
          end
        end
      end
    end
  end
end
