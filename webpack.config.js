var webpack = require('webpack');
var path = require('path');

module.exports = {
  context: __dirname,
  entry: {
    bundle: './app/index.js'
  },
  
  output: {
    path: __dirname + '/app/dist/',
    filename: '[name].js'
  },
  
  module: {
    loaders: [
      {
        test: /\.coffee$/,
        loader: 'coffee-loader'
      },
      
      {
        test: /\.css$/,
        loaders: ["style-loader", "css-loader"]
      },
      {
        test: /.*\.(gif|png|svg|jpe?g)(\?.*)?$/i,
        loader: 'url-loader?limit=25000',
      },
      {
        test: /\.(ttf|eot|otf|woff(2)?)(\?.*)?$/,
        loader: 'file-loader',
        query: {
          name: 'font/[hash].[ext]'
        }
      },
      {
        test: /[\/]angular\.js$/,
        loader: "exports-loader?angular"
      }
    ]
  },
  
  resolve: {
    alias: {
      jquery: path.join(__dirname, "bower_components/jquery/dist/jquery.js"),
      angular: path.join(__dirname, "bower_components/angular/angular.js"),
      moment: path.join(__dirname, "bower_components/moment/moment.js"),
    },
  },
  
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
    })
  ]
};
