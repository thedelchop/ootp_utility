import React from 'react';
import Root from '../Root';
import TestRenderer from 'react-test-renderer';

it('renders the Root element correctly', () => {
  const tree = TestRenderer.create(<Root />).toJSON();
  expect(tree).toMatchSnapshot();
});
