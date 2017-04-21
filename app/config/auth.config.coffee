app = angular.module('todo')

app.config ['$authProvider', ($authProvider) ->
  $authProvider.configure
    apiUrl: 'http://localhost:3000'
    authProviderPaths:
      facebook: '/auth/facebook'
]