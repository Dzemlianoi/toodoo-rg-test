app = angular.module('todo')

app.factory 'Project', ['$resource', ($resource) ->
  $resource 'http://localhost:3000/projects/:id.json', { id: '@id' },
    index:
      method: 'GET'
      isArray: true
      responseType: 'json'
    update:
      method: 'PUT'
]