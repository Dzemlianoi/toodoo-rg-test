app = angular.module('todo');

app.factory 'Comment', ['$resource', ($resource) ->
  $resource 'http://toodoo-rg.herokuapp.com/comments/:id.json', { id: '@id' },
    index:
      method: 'GET'
      isArray: true
      responseType: 'json'
      params: { project_id: '@project_id' }
    update:
      method: 'PUT'
]
