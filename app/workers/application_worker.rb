class ApplicationWorker
  include Sidekiq::Worker

  sidekiq_retries_exhausted do |msg, _ex|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end
end
