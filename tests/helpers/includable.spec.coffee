beforeEach(module('todo'))

beforeEach inject (_$httpBackend_, $compile, $rootScope, $controller, $location, $injector, $timeout) ->
  @scope = $rootScope.$new()
  @http = _$httpBackend_
  @compile = $compile
  @location = $location
  @controller = $controller
  @injector = $injector
  @timeout = $timeout
  @model = (name) ->
    @injector.get(name)
  @eventLoop =
    flush: ->
      @scope.$digest()

afterEach ->
  @http.resetExpectations()
  @http.verifyNoOutstandingExpectation()