app = angular.module('todo');

app.directive 'projectWrapper', () ->
  scope:
    'project': '=',
    'delete': '='
  templateUrl: 'views/directives/project-wrapper.html'
  controller: ['$scope', 'Task', 'Project', 'Flash', ($scope, Task, Project, Flash) ->
    $scope.tasks = $scope.project.tasks

    $scope.editProject = (project) ->
      $scope.edited_input = $('#project' + project.id + ' .task-list-name input')
      $scope.edited_input.removeAttr('readonly').focus()
      $scope.edited_input_title = project.title


    $scope.renameProject = (project) ->
      Project.update { id: project.id, title: project.title },
        () ->
          if $scope.edited_input
            $scope.edited_input.attr 'readonly', true
            $scope.edited_input = ''
          $scope.edited_input_title = ''
        (reason) ->
          if reason.data.title
            project.title = $scope.edited_input_title
            Flash.create 'danger', 'Title ' + reason.data.title.join('.<br/> Title ')

    $scope.renameProjectByEnter = (project, keyEvent) ->
       $scope.renameProject(project) if keyEvent.which is 13
  ]
#    "heroku-postbuild": "./node_modules/bower/bin/bower install"
