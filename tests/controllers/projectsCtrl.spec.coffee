describe 'ProjectsController', ->
  beforeEach ->
    @projects = [ { id: 1, title: 'first projects' }, { id: 2, title: 'second project' } ]
    @http.whenGET('http://toodoo-rg.herokuapp.com/projects.json').respond(200, @projects)
    @http.whenGET('/views/signin.html').respond(200, [])
    @controller('projectsCtrl', { $scope: @scope, $http: @http })
    @http.flush()

  describe 'load', ->
    it 'sets up the list of projects', ->
      expect(@scope.projects.length).toEqual(2)

    it 'adds a project', ->
      @http.whenPOST('http://toodoo-rg.herokuapp.com/projects.json').respond(200, { id: 3, title:'New task'})
      @scope.addProject()
      @http.flush()
      expect(@scope.projects.length).toEqual(3)

    it 'delete a project', ->
      @http.whenDELETE('http://toodoo-rg.herokuapp.com/projects/1.json').respond(200, {})
      @scope.deleteProject(@scope.projects[0])
      @http.flush()
      expect(@scope.projects.length).toEqual(1)
