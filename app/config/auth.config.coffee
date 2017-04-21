app = angular.module('todo')

app.config ['$authProvider', ($authProvider) ->
  $authProvider.configure
    apiUrl: 'https://toodoo-rg.herokuapp.com'
    authProviderPaths:
      facebook: '/auth/facebook'
]