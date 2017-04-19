app = angular.module('todo')
app.directive 'commentWrapper', () ->
  scope:
    task: '='
  templateUrl: 'views/directives/comment-wrapper.html'
  controller: [ '$scope', 'Comment', 'Flash', 'Upload', ($scope, Comment, Flash, Upload) ->
    $scope.comments = Comment.index(task_id: $scope.task.id)
    $scope.addComment = () ->
      added_comment = Upload.upload(
        url: 'http://toodoo-rg.herokuapp.com/comments/'
        data: $scope.getData()
      )
      added_comment.then(
        (response) ->
          $scope.comments.push response.data
          $scope.comment_text = ''
          $scope.file = ''
        (reason) ->
          Flash.create('danger', 'Text ' + reason.data.comment_text.join('.<br/> Text '))  if reason.data.comment_text
      )

    $scope.getData = ->
      task_id: $scope.task.id
      comment_text: $scope.comment_text
      attachment: $scope.file

    $scope.removeComment = (comment) ->
      Comment.delete { id: comment.id }, () ->
        $scope.comments = _.without $scope.comments, comment
  ]
