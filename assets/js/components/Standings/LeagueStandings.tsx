import React, { FunctionComponent } from 'react';
import {Typography, Grid} from '@material-ui/core';
import { LeagueStandings as Props}  from 'components/Standings/types'
import ConferenceStandings from 'components/Standings/ConferenceStandings';

const LeagueStandings: FunctionComponent<Props> = ({name, conference_standings}) => {
  return(
    <Grid container>
      <Typography variant="h6">{name}</Typography>
      <Grid item xs={12}>
        {conference_standings.map((standings) => <ConferenceStandings {...standings} /> )}
      </Grid>
    </Grid>
  )
}

export default LeagueStandings;
