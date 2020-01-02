import React from 'react';
import { host } from 'storybook-host';

import TradeProposalCard, { TradeProposal } from './Proposal';

export default {
  component: TradeProposalCard,
  title: 'Proposal Card',
  // Our exports that end in "Data" are not stories.
  excludeStories: /.*Data$/,
  decorators: [
    host({
      title: 'Trade Proposal Card',
      align: 'center'
    })
  ]
};

const proposalData: TradeProposal = {
  initiator: {
    name: 'Cincinnati Reds',
    logo: 'logos/reds.svg',
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
    logo: 'logos/mets.svg',
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

export const AcceptedTradeProposal = () => {
  return <TradeProposalCard {...proposalData} />;
};
