describe 'ProjectsDirective', ->
  element = null
  controller_scope = null
  tasks = [
    { id: 1, title:'first task', deadline: null, order: 1, completed: false, comments:[] },
    { id: 2, title:'second task', deadline: null, order: 2, completed: false, comments:[] }
  ]
  project = [
    id: 1,
    title: 'Title',
    tasks: tasks
  ]
  beforeEach ->
    element = angular.element('<task-wrapper project="project" tasks="tasks"></task-wrapper>')
    @scope.project = project
    @scope.tasks = tasks
    @http.whenGET('/views/signin.html').respond(200, [])
    @http.whenGET('views/directives/task-wrapper.html').respond(200, [])
    @compile(element)(@scope)
    @scope.$digest()
    @http.flush()
    controller_scope = @scope.$$childTail

  describe 'load', ->
    it 'present isolated scope variables', ->
      expect(@scope.project).toBeDefined()
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

    it 'remove task from task list', ->
      @http.whenDELETE('http://toodoo-rg.herokuapp.com/tasks/1.json').respond 200, { }
      controller_scope.removeTask(@scope.tasks[0])
      @http.flush()
      expect(@scope.tasks.length).toEqual(2)
