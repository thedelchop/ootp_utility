import React, { useState, Fragment, FunctionComponent } from 'react';
import {
  Avatar,
  Card,
  CardContent,
  CardHeader,
  Collapse,
  Divider,
  IconButton,
  List,
  ListItem,
  ListItemAvatar,
  ListItemIcon,
  ListItemSecondaryAction,
  ListItemText,
  Theme,
  Typography
} from '@material-ui/core';

import { createStyles, makeStyles } from '@material-ui/core/styles';
import { grey } from '@material-ui/core/colors';

import { Rating } from '@material-ui/lab';

import { ExpandMore, ExpandLess, StarBorderOutlined, MoreVertSharp } from '@material-ui/icons';

type Position = 'SP' | 'C' | '1B' | '2B' | '3B' | 'SS' | 'LF' | 'CF' | 'RF' | 'DH';
type Level = 'MLB' | 'AAA' | 'AA' | 'A' | 'A-' | 'R';

interface TradeAsset {
  id: string;
  name: string;
  position: Position;
  team: string;
  level: Level;
}

interface TeamOffering {
  name: string;
  logo: string;
  assets: TradeAsset[];
}

export interface TradeProposal {
  initiator: TeamOffering;
  recipient: TeamOffering;
}

const TradeAssetListItem: FunctionComponent<TradeAsset> = ({ name, position, team, level }) => {
  const useStyles = makeStyles((theme: Theme) =>
    createStyles({
      starSize: {
        fontSize: theme.typography.pxToRem(16)
      },
      potentialRating: {
        color: grey[500]
      },
      secondaryActions: {
        display: 'flex',
        alignItems: 'center',
        right: theme.typography.pxToRem(-16)
      }
    })
  );

  const classes = useStyles();

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

  const PlayerRatingsAvatar: FunctionComponent = () => (
    <List dense disablePadding>
      <ListItem dense disableGutters alignItems="center">
        <Rating
          value={Math.random() * 5}
          readOnly
          size="small"
          classes={{ sizeSmall: classes.starSize }}
          precision={0.5}
          emptyIcon={<StarBorderOutlined fontSize="inherit" />}
        />
      </ListItem>
      <ListItem dense disableGutters alignItems="center">
        <Rating
          value={Math.random() * 5}
          readOnly
          size="small"
          precision={0.5}
          emptyIcon={<StarBorderOutlined fontSize="inherit" />}
          classes={{ sizeSmall: classes.starSize, iconFilled: classes.potentialRating }}
        />
      </ListItem>
    </List>
  );

  return (
    <Fragment>
      <ListItem dense disableGutters button>
        <ListItemText
          inset
          primary={<Typography variant="body1">{name}</Typography>}
          secondary={<SecondaryText position={position} team={team} level={level} />}
        />
        <ListItemIcon>
          <PlayerRatingsAvatar />
        </ListItemIcon>
        <ListItemSecondaryAction className={classes.secondaryActions}>
          <IconButton>
            <MoreVertSharp />
          </IconButton>
        </ListItemSecondaryAction>
      </ListItem>
    </Fragment>
  );
};

const TeamOffering: FunctionComponent<TeamOffering> = ({ name, logo, assets }) => {
  const lastAssetIndex = assets.length - 1;

  return (
    <List>
      <ListItem button disableGutters>
        <ListItemAvatar>
          <Avatar variant="square" src={logo} />
        </ListItemAvatar>
        <ListItemText primary={`${name} send:`} />
      </ListItem>
      <List dense disablePadding>
        {assets.map((asset, index) => (
          <Fragment key={asset.id}>
            <TradeAssetListItem {...asset} />
            {index < lastAssetIndex && <Divider variant="inset" />}
          </Fragment>
        ))}
      </List>
    </List>
  );
};

const TradeProposalCard: FunctionComponent<TradeProposal> = ({ initiator, recipient }) => {
  const [open, setOpen] = useState(true);
  const classes = makeStyles({
    card: {
      width: 500
    }
  })();

  return (
    <Card className={classes.card} raised>
      <CardHeader
        action={
          <IconButton aria-label="settings" onClick={() => setOpen(!open)}>
            {open ? <ExpandLess /> : <ExpandMore />}
          </IconButton>
        }
        title="Boston - Cincinnati"
        subheader="December 29, 2052"
      />
      <Collapse in={open} timeout="auto" unmountOnExit>
        <CardContent>
          <TeamOffering {...initiator} />
          <Divider variant="middle" />
          <TeamOffering {...recipient} />
        </CardContent>
      </Collapse>
    </Card>
  );
};

export default TradeProposalCard;
