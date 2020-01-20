import React, { FunctionComponent } from 'react';

import { Avatar, List, ListItem, ListItemAvatar, ListItemText } from '@material-ui/core';

import { TeamOffer } from 'api/types';
import TradeAsset from 'components/TradeAsset';

const TeamOfferCard: FunctionComponent<TeamOffer> = ({ team, assets }) => {
  const { logo, name } = team;

  return (
    <List dense disablePadding>
      <ListItem disableGutters>
        <ListItemAvatar>
          <Avatar variant="square" src={logo} />
        </ListItemAvatar>
        <ListItemText primary={`${name} send:`} />
      </ListItem>
      <List dense disablePadding>
        {assets.map((asset, index) => (
          <TradeAsset key={index} {...asset} />
        ))}
      </List>
    </List>
  );
};

export default TeamOfferCard;
