import React from 'react';
import { render, cleanup } from '@testing-library/react';
import Root from '../Root';

afterEach(cleanup);

it('displays "HELLO WORLD"', () => {
  const testMessage = 'Hello World';
  const { getByText } = render(<Root />);

  // .toBeInTheDocument() is an assertion that comes from jest-dom
  // otherwise you could use .toBeDefined()
  expect(getByText(testMessage)).toBeInTheDocument();
});
