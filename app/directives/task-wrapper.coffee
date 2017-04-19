app = angular.module('todo')

app.directive 'taskWrapper', () ->
  scope:
      tasks: '=',
      project: '='
  templateUrl: 'views/directives/task-wrapper.html'
  controller: [ '$scope', 'Task', 'Flash', 'ngDialog', ($scope, Task, Flash, ngDialog) ->

      $scope.addTask = ->
        Task.save { project_id: $scope.project.id, title: $scope.task_title },
          (response) ->
            $scope.tasks.push(response)
            $scope.task_title = ''
          (reason) ->
            Flash.create('danger', 'Title ' + reason.data.title.join('.<br/> Title '))
            $('#project' + $scope.project.id +' input.new-todo').focus()

      $scope.removeTask = (task) ->
        Task.delete { id: task.id }, () ->
          $scope.tasks = window._.without($scope.tasks, task)

      $scope.updateCompleted = (task) ->
        Task.update { id: task.id, completed: task.completed }, (response) ->
          task = response

      $scope.addTaskByEnter = (task, keyEvent) ->
        $scope.addTask task if keyEvent.which is 13

      $scope.enableTitleEditing = (event, task) ->
        $scope.edited_input = $('#task' + task.id + ' .title-task')
        $scope.edited_input.removeAttr('readonly').focus()
        $scope.edited_input_title = task.title

      $scope.renameTaskByEnter =  (task, keyEvent) ->
        $scope.renameTask task if keyEvent.which is 13

      $scope.renameTask = (task) ->
        Task.update { id: task.id, title: task.title },
          () ->
            if $scope.edited_input
              $scope.edited_input.attr 'readonly', true
              $scope.edited_input = ''
            $scope.edited_input_title = ''
          (reason) ->
            $scope.setError reason, task

      $scope.setError = (reason, task) ->
        if reason.data.title
          task.title = $scope.edited_input_title
          Flash.create 'danger', 'Title ' + reason.data.title.join('.<br/> Title ')

      $scope.orderDown = (task) ->
        Task.orderDown { task_id: task.id }, (response) ->
          $scope.changePriority task, response

      $scope.orderUp = (task) ->
        Task.orderUp { task_id: task.id }, (response) ->
          $scope.changePriority task, response

      $scope.changePriority = (task, response) ->
        task.priority = response.self_task.priority
        sided_task = window._.find $scope.tasks, { id: response.sided_task.id }
        sided_task.priority = response.sided_task.priority

      $scope.checkArrow = (task) ->
        max_task = window._.last($scope.tasks)
        max_task.priority is task.priority

      $scope.isCompleted = (task) ->
        if task.completed then 'Yes' else 'No'

      $scope.openTab = (task) ->
        $scope.editedTask = task
        ngDialog.open
          template: 'views/modal/task-details-modal.html'
          width: 520
          scope: $scope
          task: task

      $scope.saveTask = (task) ->
        $scope.editedDeadline = task.deadline

      $scope.setDeadline = (newTime, oldTime, task) ->
        Task.update { id: task.id, deadline: newTime },
          (response) ->
            task.deadline = response.deadline
          (reason) ->
            Flash.create 'danger', reason.data.deadline[0]
  ]
