describe 'ProjectsDirective', ->
  element = null
  controller_scope = null
  beforeEach ->
    element = angular.element('<project-wrapper project="project"></project-wrapper>')
    @scope.project = { id: 1, title: 'First title', tasks: [ id: 1 ] }
    @http.whenGET('/views/signin.html').respond(200, [])
    @http.whenGET('views/directives/project-wrapper.html').respond(200, [])
    @compile(element)(@scope)
    @scope.$digest()
    @http.flush()
    controller_scope = @scope.$$childTail

  describe 'load', ->
    it 'sets up the list of tasks', ->
      expect(@scope.project).toBeDefined()
      expect(controller_scope.tasks).toBeDefined()
      expect(controller_scope.tasks.length).toEqual(1)

  describe 'editing', ->
    it 'should on editing mode', ->
      controller_scope.editProject(@scope.project)
      expect(controller_scope.edited_input_title).toEqual(@scope.project.title)

  describe 'renaming', ->
    it 'should rename Project', ->
      @http.expect('PUT', 'http://toodoo-rg.herokuapp.com/projects/1.json',
        id: @scope.project.id
        title: @scope.project.title
      ).respond 200, { id: 1, title: 'First title' }
      controller_scope.renameProject(@scope.project)
      @http.flush()

    it 'should clear edited title', ->
      controller_scope.edited_input_title = 'Test'
      @http.whenPUT('http://toodoo-rg.herokuapp.com/projects/1.json').respond 200, {}
      controller_scope.renameProject(@scope.project)
      @http.flush()
      expect(controller_scope.edited_input_title).toBe('')
