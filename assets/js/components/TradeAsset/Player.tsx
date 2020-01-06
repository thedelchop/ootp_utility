import React, { FunctionComponent } from 'react';
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

import { Player, Team, Position, Level } from 'api/types';
import PlayerRatingsAvatar from 'components/PlayerRatingsAvatar';

interface SecondaryTextProps {
  level: Level;
  position: Position;
  team: string;
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

type OwnProps = Pick<Player, 'name' | 'position' | 'overallRating' | 'potentialRating'> & { team: Team };

const PlayerTradeAsset: FunctionComponent<OwnProps> = ({
  name,
  position,
  team: { name: teamName, level },
  overallRating,
  potentialRating
}) => {
  const classes = useStyles();

  return (
    <ListItem dense disableGutters button>
      <ListItemText
        inset
        primary={<Typography variant="body1">{name}</Typography>}
        secondary={<SecondaryText position={position} team={teamName} level={level} />}
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
  );
};

export default PlayerTradeAsset;
