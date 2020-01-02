import React, { FunctionComponent } from 'react';

import TradeProposalCard, { TradeProposal } from 'components/Trades/Proposal';

const proposalData: TradeProposal = {
  initiator: {
    name: 'Cincinnati Reds',
    logo: 'reds',
    assets: [
      {
        id: '1',
        name: 'Shawn Lewis',
        position: 'SP',
        team: 'Cincinnati Reds',
        level: 'MLB'
      },
      {
        id: '2',
        name: 'Rod Griffin',
        position: 'CF',
        team: 'Poland Whiskeyjacks',
        level: 'A-'
      },
      {
        id: '3',
        name: 'Robby Dropo',
        position: 'SP',
        team: 'Sarasota Reds',
        level: 'A'
      }
    ]
  },
  recipient: {
    name: 'New York Mets',
    logo: 'mets',
    assets: [
      {
        id: '4',
        name: 'Myron Vazquez',
        position: 'RF',
        team: 'New York Mets',
        level: 'MLB'
      },
      {
        id: '5',
        name: 'Bud Dailey',
        position: 'SP',
        team: 'Binghamton Mets',
        level: 'AA'
      }
    ]
  }
};

const Root: FunctionComponent = () => <TradeProposalCard {...proposalData} />;

export default Root;
