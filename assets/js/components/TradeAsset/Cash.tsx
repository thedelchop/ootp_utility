import React, { FunctionComponent } from 'react';
import { ListItemText, Typography } from '@material-ui/core';
import { CashTradeAsset } from 'api/types';
import TradeAssetContainer from 'components/TradeAsset/Container';

const currencyRegex = /(\d)(?=(\d{3})+(?!\d))/g;

const toCurrency = (cashValue: number): string => `$${cashValue.toFixed(0).replace(currencyRegex, '$1,')}`;

const CashTradeAssetCard: FunctionComponent<CashTradeAsset> = ({ amount }) => {
  return (
    <TradeAssetContainer>
      <ListItemText inset primary={<Typography variant="body1">{toCurrency(amount)} Cash</Typography>} />
    </TradeAssetContainer>
  );
};

export default CashTradeAssetCard;
