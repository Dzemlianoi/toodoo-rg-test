describe 'ProjectsDirective', ->
  element = null
  controller_scope = null
  tasks = [
    { id: 1, title:'first task', deadline: null, priority: 1, completed: false, comments:[] },
    { id: 2, title:'second task', deadline: null, priority: 2, completed: false, comments:[] }
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

  describe 'removing', ->
    it 'changes quantity of tasks by 1', ->
      @http.whenDELETE('http://toodoo-rg.herokuapp.com/tasks/1.json').respond 200, { }
      controller_scope.removeTask(@scope.tasks[0])
      @http.flush()
      expect(@scope.tasks.length).toEqual(2)

  describe 'updating', ->
    it 'change updating', ->
      @http.expect('PUT', 'http://toodoo-rg.herokuapp.com/tasks/1.json',
        id: @scope.tasks[0].id
        completed: @scope.tasks[0].completed
      ).respond 200, { }
      controller_scope.updateCompleted(@scope.tasks[0])
      @http.flush()

    it 'enables title editing', ->
      controller_scope.enableTitleEditing(null, @scope.tasks[0])
      expect(controller_scope.edited_input_title).toEqual(@scope.tasks[0].title)

    it 'renames task', ->
      @http.expect('PUT', 'http://toodoo-rg.herokuapp.com/tasks/1.json',
        id: @scope.tasks[0].id
        title: @scope.tasks[0].title
      ).respond 200, { id: 1, title: 'First title' }
      controller_scope.renameTask(@scope.tasks[0])
      @http.flush()

  describe 'error', ->
    it 'sets error', ->
      controller_scope.edited_input_title = 'test'
      test = data: { title: ['first task'] }
      controller_scope.setError(test, @scope.tasks[0])
      expect(@scope.tasks[0].title).toBe('test')

  describe 'ordering', ->
    it 'orders down', ->
      @http.when('PATCH', 'http://toodoo-rg.herokuapp.com/tasks/' + @scope.tasks[0].id + '/order_down',
        task_id: @scope.tasks[0].id
      ).respond(200, { self_task: @scope.tasks[0], sided_task: @scope.tasks[1] })
      controller_scope.orderDown(@scope.tasks[0])
      @http.flush()
      expect(@scope.tasks[0].priority).toEqual(2)
      expect(@scope.tasks[1].priority).toEqual(1)

    it 'orders up', ->
      @http.when('PATCH', 'http://toodoo-rg.herokuapp.com/tasks/' + @scope.tasks[1].id + '/order_down',
        task_id: @scope.tasks[1].id
      ).respond(200, { self_task: @scope.tasks[0], sided_task: @scope.tasks[0] })
      controller_scope.orderDown(@scope.tasks[1])
      @http.flush()
      expect(@scope.tasks[1].priority).toEqual(2)
      expect(@scope.tasks[0].priority).toEqual(1)

  describe 'completing', ->
    it 'should return No if task isnt completed', ->
      expect(controller_scope.isCompleted(@scope.tasks[0])).toBe('No')

    it 'should return Yes if task is completed', ->
      expect(controller_scope.isCompleted(completed: true)).toBe('Yes')

  describe 'does arrow should be shown', ->
    it 'should not present for last task', ->
      expect(controller_scope.checkArrow(@scope.tasks[2])).toBeTruthy()

    it 'should not present for last task', ->
      expect(controller_scope.checkArrow(@scope.tasks[0])).toBeFalsy()

  describe 'open modal window', ->
    it 'should be opened', ->
      @http.whenGET('views/modal/task-details-modal.html').respond 200, {}
      controller_scope.openTab @scope.tasks[0]
      expect(controller_scope.editedTask).toBe @scope.tasks[0]

  describe 'deadline setting', ->
    it 'should save task', ->
      controller_scope.saveTask(@scope.tasks[0])
      expect(controller_scope.editedDeadline).toBe(@scope.tasks[0].deadline)

    it 'should set deadline', ->
      @http.when('PUT', 'http://toodoo-rg.herokuapp.com/tasks/1.json',
        id: @scope.tasks[0].id,
        deadline: false
      ).respond(200, { deadline: true })
      controller_scope.setDeadline(false, false, @scope.tasks[0])
      @http.flush()
      expect(@scope.tasks[0].deadline).toBeTruthy()
