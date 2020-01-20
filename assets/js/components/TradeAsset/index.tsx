import React, { FunctionComponent } from 'react';
import PlayerTradeAsset from 'components/TradeAsset/Player';
import CashTradeAsset from 'components/TradeAsset/Cash';
import DraftPickTradeAsset from 'components/TradeAsset/DraftPick';

import { TradeAsset } from 'api/types';

const TradeAssetCard: FunctionComponent<TradeAsset> = (asset) => {
  switch (asset.type) {
    case 'Cash':
      return <CashTradeAsset {...asset} />;
    case 'DraftPick':
      return <DraftPickTradeAsset {...asset} />;
    default:
      return <PlayerTradeAsset {...asset} />;
  }
};

export default TradeAssetCard;
