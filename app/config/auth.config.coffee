app = angular.module('todo')

app.config ['$authProvider', ($authProvider) ->
  $authProvider.configure
    apiUrl: 'http://toodoo-rg.herokuapp.com'
]