import React, { FunctionComponent } from 'react';

import { List, ListItem } from '@material-ui/core';
import { makeStyles } from '@material-ui/core/styles';
import { grey, yellow } from '@material-ui/core/colors';
import { Rating } from '@material-ui/lab';
import { StarBorder } from '@material-ui/icons';

import { PlayerRating, PlayerRatingType } from 'api/types';

interface PlayerRatingProps {
  rating: PlayerRating;
  type?: PlayerRatingType;
}

const useStyles = makeStyles({
  starColor: {
    color: ({ type }: PlayerRatingProps) => (type == 'Potential' ? grey[500] : yellow[400])
  }
});

const PlayerRatingsAvatar: FunctionComponent<PlayerRatingProps> = ({ rating, type = 'Actual' }) => {
  const styles = useStyles({ type, rating });

  return (
    <Rating
      value={rating}
      readOnly
      size="small"
      classes={{ iconFilled: styles.starColor }}
      precision={0.5}
      emptyIcon={<StarBorder fontSize="inherit" htmlColor="transparent" />}
    />
  );
};

interface Props {
  overallRating: PlayerRating;
  potentialRating: PlayerRating;
}

const PlayerRatings: FunctionComponent<Props> = ({ overallRating, potentialRating }) => {
  return (
    <List dense disablePadding>
      <ListItem dense disableGutters alignItems="center">
        <PlayerRatingsAvatar rating={overallRating} />
      </ListItem>
      <ListItem dense disableGutters alignItems="center">
        <PlayerRatingsAvatar rating={potentialRating} type="Potential" />
      </ListItem>
    </List>
  );
};

export default PlayerRatings;
