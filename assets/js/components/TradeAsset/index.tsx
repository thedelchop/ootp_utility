import React, { FunctionComponent } from 'react';
import PlayerTradeAsset from 'components/TradeAsset/Player';
import CashTradeAsset from 'components/TradeAsset/Cash';
import DraftPickTradeAsset from 'components/TradeAsset/DraftPick';

import { TradeAsset, Cash, DraftPick } from 'api/types';

const isCash = (asset: TradeAsset): asset is Cash => typeof asset == 'number';
const isDraftPick = (asset: TradeAsset): asset is DraftPick => !!Object.keys(asset).includes('round');

const TradeAssetCard: FunctionComponent<TradeAsset> = (asset) => {
  if (isCash(asset)) {
    return <CashTradeAsset {...asset} />;
  } else if (isDraftPick(asset)) {
    return <DraftPickTradeAsset {...asset} />;
  } else {
    return <PlayerTradeAsset {...asset} />;
  }
};

export default TradeAssetCard;
