import React, { FunctionComponent } from 'react';
import { IconButton, ListItem, ListItemSecondaryAction, ListItemText, Typography } from '@material-ui/core';
import { MoreVertSharp } from '@material-ui/icons';
import { Cash } from 'api/types';

const currencyRegex = /(\d)(?=(\d{3})+(?!\d))/g;

const toCurrency = (cashValue: number): string => `$${cashValue.toFixed(2).replace(currencyRegex, '$1,')}`;

const CashTradeAsset: FunctionComponent<Cash> = (cashValue) => (
  <ListItem dense disableGutters button>
    <ListItemText inset primary={<Typography variant="body1">{toCurrency(cashValue)}</Typography>} />
    <ListItemSecondaryAction>
      <IconButton>
        <MoreVertSharp />
      </IconButton>
    </ListItemSecondaryAction>
  </ListItem>
);

export default CashTradeAsset;
