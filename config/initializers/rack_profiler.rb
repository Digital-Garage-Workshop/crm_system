# frozen_string_literal: true

<<<<<<< HEAD
if Rails.env.development?
=======
if Rails.env.development? && ENV['DISABLE_MINI_PROFILER'].blank?
>>>>>>> upstream/develop
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
