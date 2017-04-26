module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: [
      './app/dist/underscore.js',
      './bower_components/jquery/dist/jquery.js',
      './bower_components/angular/angular.js',
      './node_modules/angular-mocks/angular-mocks.js',
      './bower_components/jquery/dist/jquery.js',
      './bower_components/angular-resource/angular-resource.js',
      './bower_components/angular-ui-router/release/angular-ui-router.js',
      './bower_components/angular-cookie/angular-cookie.js',
      './bower_components/ng-token-auth/dist/ng-token-auth.js',
      './bower_components/angular-flash-alert/dist/angular-flash.js',
      './bower_components/ng-dialog/js/ngDialog.js',
      './bower_components/ng-file-upload/ng-file-upload.js',
      './bower_components/angular-animate/angular-animate.js',
      './bower_components/angular-messages/angular-messages.js',
      './app/modules/*.coffee',
      './app/config/*.coffee',
      './app/controllers/*.coffee',
      './app/directives/*.coffee',
      './app/factories/*.coffee',
      './tests/**/*.coffee'
    ],
    exclude: [
      './app/config/index.config.coffee',
      './app/controllers/indexCtrl.coffee',
      './app/directives/indexDirective.coffee',
      './app/factories/indexFactory.coffee'
    ],
    preprocessors: {
      './**/*.coffee': ['coffee']
    },
    reporters: ['progress'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome'],
    singleRun: false,
    concurrency: Infinity
  })
};
