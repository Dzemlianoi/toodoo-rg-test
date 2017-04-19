app = angular.module('todo')

app.config ($stateProvider, $urlRouterProvider) ->
  unpermited = access: ['$auth', '$state', ($auth, $state) ->
    $auth.validateUser().then(
      ->
        $state.go 'home',
      ->
        true
    )
  ]
  
  $stateProvider
    .state('signin',
      url: '/'
      controller: 'signinCtrl'
      templateUrl: '/views/signin.html'
      resolve: unpermited
    )
    .state('signup',
      url: '/signup'
      controller: 'signupCtrl'
      templateUrl: '/views/signup.html'
      resolve: unpermited
    )
    .state 'home',
      url: '/todo'
      controller: 'projectsCtrl'
      templateUrl: '/views/projects.html'
      resolve:
        auth: ($auth) -> $auth.validateUser()
  
  $urlRouterProvider.otherwise '/'