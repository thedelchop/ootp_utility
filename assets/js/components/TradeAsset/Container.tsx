import React, { FunctionComponent } from 'react';
import { IconButton, ListItem, ListItemSecondaryAction } from '@material-ui/core';
import { MoreVertSharp } from '@material-ui/icons';

const TradeAssetContainer: FunctionComponent = ({ children }) => (
  <ListItem dense disableGutters>
    {children}
    <ListItemSecondaryAction>
      <IconButton>
        <MoreVertSharp />
      </IconButton>
    </ListItemSecondaryAction>
  </ListItem>
);

export default TradeAssetContainer;
