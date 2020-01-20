import React, { FunctionComponent } from 'react';
import { ListItemText, Typography } from '@material-ui/core';

import { Player, Team, Position, Level } from 'api/types';
import PlayerRatingsAvatar from 'components/PlayerRatingsAvatar';
import TradeAssetContainer from 'components/TradeAsset/Container';

interface SecondaryTextProps {
  level: Level;
  position: Position;
  team: string;
}

type OwnProps = Pick<Player, 'name' | 'position' | 'overallRating' | 'potentialRating'> & { team: Team };

const SecondaryText: FunctionComponent<SecondaryTextProps> = ({ position, team, level }) => (
  <Typography variant="overline" color="textSecondary" display="inline">
    {position} | {team} ({level})
  </Typography>
);

const PlayerTradeAsset: FunctionComponent<OwnProps> = ({
  name,
  position,
  team: { name: teamName, level },
  overallRating,
  potentialRating
}) => (
  <TradeAssetContainer>
    <ListItemText
      inset
      primary={<Typography variant="body1">{name}</Typography>}
      secondary={<SecondaryText position={position} team={teamName} level={level} />}
    />
    <PlayerRatingsAvatar overallRating={overallRating} potentialRating={potentialRating} />
  </TradeAssetContainer>
);

export default PlayerTradeAsset;
