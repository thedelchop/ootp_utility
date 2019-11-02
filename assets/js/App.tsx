import React, { Fragment } from 'react';
import ReactDOM from 'react-dom';
import CssBaseline from '@material-ui/core/CssBaseline';
import Root from 'components/Root';

// This code starts up the React app when it runs in a browser. It sets up the routing configuration and injects the app into a DOM element.
ReactDOM.render(
  <Fragment>
    <CssBaseline />
    <Root />
  </Fragment>,
  document.getElementById('react-app')
);
