app = angular.module("myApp", [ "ngDialog" ])

app.config [ "ngDialogProvider", (ngDialogProvider) ->
  ngDialogProvider.setDefaults
    className: "ngdialog-theme-default custom-width"
    showClose: true
    closeByEscape: true
]