import React, { FunctionComponent } from 'react';

import { List, ListItem, Theme } from '@material-ui/core';
import { createStyles, makeStyles } from '@material-ui/core/styles';
import { grey, yellow } from '@material-ui/core/colors';
import { Rating } from '@material-ui/lab';
import { StarBorderOutlined } from '@material-ui/icons';

import { PlayerRating, PlayerRatingType } from 'api/types';

interface PlayerRatingProps {
  rating: PlayerRating;
  type?: PlayerRatingType;
}

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    starSize: {
      fontSize: theme.typography.pxToRem(16)
    },
    starColor: {
      color: ({ type }: PlayerRatingProps) => (type == 'Potential' ? grey[500] : yellow['A200'])
    }
  })
);

const PlayerRatingsAvatar: FunctionComponent<PlayerRatingProps> = ({ rating, type = 'Actual' }) => {
  const styles = useStyles({ type, rating });

  return (
    <Rating
      value={rating}
      readOnly
      size="small"
      classes={{ sizeSmall: styles.starSize, iconFilled: styles.starColor }}
      precision={0.5}
      emptyIcon={<StarBorderOutlined fontSize="inherit" />}
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
