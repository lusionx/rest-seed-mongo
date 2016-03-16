
redis =
  host: '192.168.4.104'
  port: 6379
  namespace: 'restmg'

conf =
  service:
    name: 'rest mongo'
    version: '0.0.1'
    port: 8100

  db: 'mongodb://10.10.3.113:27017/test'

  apiRoot: '/api_v2'

  redis: redis

module.exports = conf
