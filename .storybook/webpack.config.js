const path = require('path');

module.exports = ({ config, mode }) => {
  config.module.rules.push({
    test: /\.(ts|tsx)$/,
    loader: require.resolve('babel-loader'),
    options: {
      presets: [['react-app', { flow: false, typescript: true }]],
    },
  });

  config.resolve.extensions.push('.ts', '.tsx');
  config.resolve.modules.push(path.resolve('./node_modules'))
  config.resolve.modules.push(path.resolve('./assets/js'))
  config.resolve.modules.push(path.resolve('./assets/static/images'))

  return config;
};
