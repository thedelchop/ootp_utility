const path = require('path');

module.exports = {
  stories: [
    "../stories/**/*.stories.js"
  ],
  addons: [
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    {
      name: "@storybook/addon-postcss",
      options: {
        postcssLoaderOptions: {
          implementation: require('postcss')
        }
      }
    }
  ],
  webpackFinal: async (config, { configType }) => {
    // `configType` has a value of 'DEVELOPMENT' or 'PRODUCTION'
    // You can change the configuration based on that.
    // 'PRODUCTION' is used when building the static version of storybook.
    //
    config.resolve.modules.push(path.resolve(__dirname, '../../deps'))

    // Make whatever fine-grained changes you need
    config.module.rules.push({
      test: /\.js$/,
      loader: 'esbuild-loader',
      options: {
        target: 'es2015'  // Syntax to compile to (see options below for possible values)
      }
    });

    // Return the altered config
    return config;
  },
}
