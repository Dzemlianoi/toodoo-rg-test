describe 'ProjectsDirective', ->
  element = null
  controller_scope = null
  task =
    id: 1
    title:'first task'
    deadline: null
    priority: 1
    completed: false
    comments:[ { id: 1, comment_text: 'Test'}]
  beforeEach ->
    element = angular.element('<comment-wrapper task="task"></comment-wrapper>')
    @scope.task = task
    @http.whenGET('/views/signin.html').respond(200, [])
    @http.whenGET('views/directives/comment-wrapper.html').respond(200, [])
    @http.whenGET('http://toodoo-rg.herokuapp.com/comments/').respond(200, @scope.task.comments)
    @compile(element)(@scope)
    @scope.$digest()
    @http.flush()
    controller_scope = @scope.$$childTail

  describe 'load', ->
    it 'present isolated scope variables', ->
      expect(@scope.task).toBeDefined()
      expect(@scope.tasks).toBeDefined()

    it 'add task to task list', ->
      controller_scope.task_title = 'First task'
      @http.expect('POST', 'http://toodoo-rg.herokuapp.com/tasks.json',
        id: @scope.project.id
        title: controller_scope.task_title
      ).respond 200, { id: 1, title: 'First title' }
      controller_scope.addTask()
      @http.flush()
      expect(@scope.tasks.length).toEqual(3)
      expect(controller_scope.task_title).toBe('')

  describe 'removing', ->
    it 'changes quantity of tasks by 1', ->
      @http.whenDELETE('http://toodoo-rg.herokuapp.com/tasks/1.json').respond 200, { }
      controller_scope.removeTask(@scope.tasks[0])
      @http.flush()
      expect(@scope.tasks.length).toEqual(2)
