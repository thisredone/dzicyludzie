{ log } = require 'util'
enablebanking = require 'enablebanking'
fetch = require 'node-fetch'


nordeaSettings = [
  true, # sandbox
  null, # consentId
  null, # accessToken
  null, # refreshToken
  "!!! CLIENT ID TO BE INSERTED HERE !!!", # clientId
  "!!! CLIENT SECRET TO BE INSERTED HERE !!!", # clientSecret
  "/path/to/a/qwac/cert.cer", # certPath
  "/path/to/a/qseal/signature/key.pem", # keyPath
  'PL', # country
  1000, # sessionDuration
  null, # language
  "https://enablebanking.com/consent-redirect-callback" # tppRedirectUri
]

getResponseCode = (url) ->
  qs = url.split('?')[1]
  pairs = qs.split('&')
  for pair in pairs
    [key, value] = pair.split('=')
    return value if key is code
  null


do ->
  apiClient = new enablebanking.ApiClient('Nordea', nordeaSettings)
  authApi = new enablebanking.AuthApi(apiClient)
  getAuthResult = await authApi.getAuth(
    'code',
    'https://enablebanking.com',
    ['aisp'], {
      state: 'test'
    }
  )
  # follow the url to make user authorization
  # usually you need to do a few clicks in the UI
  authResult = await fetch(getAuthResult.url)
  responseCode = getResponseCode(authResult.url)
  # token is returned and also saved inside `apiClient`
  makeTokenResponse = await authApi.makeToken(
    'authorization_code',
    responseCode, {
      redirectUri: 'https://enablebanking.com'
    }
  )
  aispApi = new enablebanking.AISPApi(apiClient)
  accounts = await aispApi.getAccounts()
  console.log(accounts)
  accountId = accounts.accounts[0].resourceId
  accountTransactions = await aispApi.getAccountTransactions(accountId)
  console.log(accountTransactions)

  console.log("All done!")
