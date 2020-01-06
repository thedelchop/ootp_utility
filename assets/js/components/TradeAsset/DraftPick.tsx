import React, { FunctionComponent } from 'react';
import { IconButton, ListItem, ListItemSecondaryAction, ListItemText, Typography } from '@material-ui/core';
import { MoreVertSharp } from '@material-ui/icons';
import { DraftPick } from 'api/types';

const toOrdinal = (num: number): string => {
  const digits = [num % 10, num % 100],
    ordinals = ['st', 'nd', 'rd', 'th'],
    oPattern = [1, 2, 3, 4],
    tPattern = [11, 12, 13, 14, 15, 16, 17, 18, 19];
  return oPattern.includes(digits[0]) && !tPattern.includes(digits[1])
    ? num + ordinals[digits[0] - 1]
    : num + ordinals[3];
};

const DraftPickTradeAsset: FunctionComponent<DraftPick> = ({ year, round }) => (
  <ListItem dense disableGutters button>
    <ListItemText
      inset
      primary={<Typography variant="body1">{`${year} ${toOrdinal(round)} round draft pick`}</Typography>}
    />
    <ListItemSecondaryAction>
      <IconButton>
        <MoreVertSharp />
      </IconButton>
    </ListItemSecondaryAction>
  </ListItem>
);

export default DraftPickTradeAsset;
