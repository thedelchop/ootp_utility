import React, { Fragment, FunctionComponent } from 'react';
import {
  IconButton,
  ListItem,
  ListItemIcon,
  ListItemSecondaryAction,
  ListItemText,
  Theme,
  Typography
} from '@material-ui/core';
import { createStyles, makeStyles } from '@material-ui/core/styles';
import { MoreVertSharp } from '@material-ui/icons';

import { TradeAsset, Position } from 'api/types';
import PlayerRatingsAvatar from 'components/PlayerRatingsAvatar';

interface SecondaryTextProps {
  position: Position;
  team: string;
  level: string;
}

const SecondaryText: FunctionComponent<SecondaryTextProps> = ({ position, team, level }) => (
  <Typography variant="overline" color="textSecondary" display="inline">
    {position} | {team} ({level})
  </Typography>
);

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    secondaryActions: {
      display: 'flex',
      alignItems: 'center',
      right: theme.typography.pxToRem(-16)
    }
  })
);

const TradeAsset: FunctionComponent<TradeAsset> = ({ name, position, team, level, overallRating, potentialRating }) => {
  const classes = useStyles();

  return (
    <Fragment>
      <ListItem dense disableGutters button>
        <ListItemText
          inset
          primary={<Typography variant="body1">{name}</Typography>}
          secondary={<SecondaryText position={position} team={team} level={level} />}
        />
        <ListItemIcon>
          <PlayerRatingsAvatar overallRating={overallRating} potentialRating={potentialRating} />
        </ListItemIcon>
        <ListItemSecondaryAction classes={{ root: classes.secondaryActions }}>
          <IconButton>
            <MoreVertSharp />
          </IconButton>
        </ListItemSecondaryAction>
      </ListItem>
    </Fragment>
  );
};

export default TradeAsset;
