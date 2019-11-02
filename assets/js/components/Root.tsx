import React, { FunctionComponent } from 'react';
import Button from '@material-ui/core/Button';
import {Grid} from '@material-ui/core';

const Root: FunctionComponent = () => (
  <Grid>
    <Button variant="contained" color="primary">
      Hello World
    </Button>
  </Grid>
);

export default Root;
