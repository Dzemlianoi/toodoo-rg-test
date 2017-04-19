app = angular.module('todo')

app.factory 'Project', ['$resource', ($resource) ->
  $resource 'https://toodoo-rg.herokuapp.com/projects/:id.json', { id: '@id' },
    index:
      method: 'GET'
      isArray: true
      responseType: 'json'
    update:
      method: 'PUT'
]