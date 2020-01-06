import React, { Fragment, FunctionComponent } from 'react';

import { Avatar, Divider, List, ListItem, ListItemAvatar, ListItemText } from '@material-ui/core';

import { TeamOffer } from 'api/types';
import TradeAsset from 'components/TradeAsset';

const TeamOffer: FunctionComponent<TeamOffer> = ({ team, assets }) => {
  const { logo, name } = team;
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
          <Fragment key={index}>
            <TradeAsset {...asset} />
            {index < lastAssetIndex && <Divider variant="inset" />}
          </Fragment>
        ))}
      </List>
    </List>
  );
};

export default TeamOffer;
