import React, { FunctionComponent } from 'react';
import { Typography, Grid } from '@material-ui/core';
import DivisionStandings from 'components/Standings/DivisionStandings';
import { ConferenceStandings as Props } from 'components/Standings/types'

const ConferenceStandings: FunctionComponent<Props> = ({name, division_standings}) => {
  return(
    <Grid container>
      <Typography variant="h6">{name}</Typography>
      <Grid item xs={6}>
        {division_standings.map((standings) => <DivisionStandings {...standings} /> )}
      </Grid>
    </Grid>
  )
}

export default ConferenceStandings;
