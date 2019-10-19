if ENV.fetch("RAILS_ENV") == 'production'
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }

  preload_app!

  before_fork do
    # require 'puma_worker_killer'
    # PumaWorkerKiller.enable_rolling_restart # Default is every 6 hours

    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)

  end

  on_worker_boot do
    # Worker specific setup for Rails 4.1+
    # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end

end

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }
plugin :tmp_restart
