json.array! @resources do |resource|
<<<<<<< HEAD
  json.partial! 'platform/api/v1/models/agent_bot', formats: [:json], resource: resource.permissible
=======
  bot = resource.permissible
  next if bot.nil?

  json.partial! 'platform/api/v1/models/agent_bot', formats: [:json], resource: bot
>>>>>>> upstream/develop
end
