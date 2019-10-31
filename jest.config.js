// jest.config.js
// const { pathsToModuleNameMapper } = require('ts-jest/utils');
// In the following statement, replace `./tsconfig` with the path to your `tsconfig` file
// which contains the path mapping (ie the `compilerOptions.paths` option):

module.exports = {
  roots: ['<rootDir>/assets/js/'],
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['./jest.setup.ts']
};
