app = angular.module('todo');

app.config((FlashProvider) ->
  FlashProvider.setTimeout(7000)
  FlashProvider.setShowClose(true)
)