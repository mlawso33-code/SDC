const path = require('path');
const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');
const SRC_DIR = path.join(__dirname, '/client/src')
const DIST_DIR = path.join(__dirname, '/client/dist')

module.exports = merge(common, {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    static: DIST_DIR,
  },
});