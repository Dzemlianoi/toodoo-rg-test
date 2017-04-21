app = angular.module('todo')

app.controller 'signinCtrl', [ '$scope', '$auth', '$state', 'Flash', ($scope, $auth, $state, Flash) ->
  $scope.$on 'auth:login-success', ->
    Flash.create 'success', 'Log in successfully'
    $state.go 'home'

  $scope.$on 'auth:login-error', (ev, reason) ->
    return if (reason.errors[0] is 'Invalid login credentials. Please try again.')
    Flash.create 'danger', reason.errors[0]  if reason and reason.errors

  $scope.$on 'auth:logout-success', ->
    Flash.create 'success', 'Log out successfully'
    $state.go 'signin'
]