const path = require('path');

module.exports = {
  entry: './src/Ports/watch.ts',
  module: {
    rules: [
      {
        test: /\.ts?$/,
        use: 'ts-loader',
        exclude: [
          /node_modules/,
          /src\/test\//
        ]
      }
    ]
  },
  target: 'electron-renderer',
  resolve: {
    extensions: ['.ts']
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, 'dist')
  }
};
