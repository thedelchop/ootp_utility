import React, { FunctionComponent } from 'react';
import {Table, TableHead, TableRow, TableBody, TableCell} from '@material-ui/core';
import TeamRecord from 'components/Standings/TeamRecord';
import { DivisionStandings as Props } from 'components/Standings/types'

const DivisionStandings: FunctionComponent<Props> = ({name, team_records}) => {
  return(
    <Table>
      <TableHead>
        <TableRow>
          <TableCell>{name}</TableCell>
          <TableCell>W</TableCell>
          <TableCell>L</TableCell>
          <TableCell>PCT</TableCell>
          <TableCell>GB</TableCell>
          <TableCell>STRK</TableCell>
          <TableCell>NUM</TableCell>
        </TableRow>
      </TableHead>
      <TableBody>
        {team_records.map((team_record) => <TeamRecord {...team_record} /> )}
      </TableBody>
    </Table>
  )
}

export default DivisionStandings;
