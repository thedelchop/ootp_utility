import React, { FunctionComponent } from 'react';
import {TableRow, TableCell} from '@material-ui/core';
import {TeamRecord as Props} from 'components/Standings/types';

const TeamRecord: FunctionComponent<Props> = ({
  name,
  record:{
    wins,
    losses,
    winning_percentage,
    games_behind,
    streak,
    magic_number
  }
}) => (
  <TableRow>
    <TableCell>{name}</TableCell>
    <TableCell>{wins}</TableCell>
    <TableCell>{losses}</TableCell>
    <TableCell>{winning_percentage}</TableCell>
    <TableCell>{games_behind}</TableCell>
    <TableCell>{streak}</TableCell>
    <TableCell>{magic_number}</TableCell>
  </TableRow>
);

export default TeamRecord;
