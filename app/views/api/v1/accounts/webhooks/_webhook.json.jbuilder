json.id webhook.id
<<<<<<< HEAD
json.url webhook.url
json.account_id webhook.account_id
json.subscriptions webhook.subscriptions
=======
json.name webhook.name
json.url webhook.url
json.account_id webhook.account_id
json.subscriptions webhook.subscriptions
json.secret webhook.secret
>>>>>>> upstream/develop
if webhook.inbox
  json.inbox do
    json.id webhook.inbox.id
    json.name webhook.inbox.name
  end
end
