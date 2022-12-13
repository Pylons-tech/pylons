/* eslint-disable @typescript-eslint/no-var-requires */
const { pathsToModuleNameMapper } = require('ts-jest')
const { compilerOptions } = require('./tsconfig.json')
module.exports = {
  collectCoverageFrom: [
    '**/*.{js,jsx,ts,tsx}',
    '!**/@next/ApiReq/*',
    '!**/@next/utils/*',
    '!**/@next/hooks/*',
    '!**/@next/store/slices/auth/*',
    '!**/*.d.ts',
    '!**/node_modules/**',
    '!<rootDir>/pages/**',
    '!<rootDir>/out/**',
    '!<rootDir>/.next/**',
    '!<rootDir>/*.config.js',
    '!<rootDir>/coverage/**'
  ],
  moduleDirectories: ['node_modules', '<rootDir>/node_modules', '.'],
  moduleNameMapper: {
    ...pathsToModuleNameMapper(compilerOptions.paths, { prefix: '<rootDir>/' }),
    /* Handle CSS imports (with CSS modules)

        https://jestjs.io/docs/webpack#mocking-css-modules */
    '\\.svg$': '<rootDir>/__mocks__/svg.js',
    '^.+\\.module\\.(css|sass|scss)$': 'identity-obj-proxy',

    // Handle CSS imports (without CSS modules)
    '^.+\\.(css|sass|scss)$': '<rootDir>/__mocks__/styleMock.ts',

    /* Handle image imports
        https://jestjs.io/docs/webpack#handling-static-assets */
    '^.+\\.(jpg|jpeg|png|gif|webp)$': '<rootDir>/__mocks__/fileMock.ts',

    //Handle module aliases
    '^@/components/(.*)$': '<rootDir>/components/$1'
  },
  testPathIgnorePatterns: ['<rootDir>/node_modules/', '<rootDir>/\\.next/'],
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  transform: {
    /* Use babel-jest to transpile tests with the next/babel preset
        https://jestjs.io/docs/configuration#transform-objectstring-pathtotransformer--pathtotransformer-object */
    '^.+\\.(js|jsx|ts|tsx|svg)$': ['babel-jest', { presets: ['next/babel'] }]
  },
  transformIgnorePatterns: ['/node_modules/', '^.+\\.module\\.(css|sass|scss)$']
}
