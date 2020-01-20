import React from 'react';
import { host } from 'storybook-host';

import { TradeProposal } from 'api/types';

import Proposal from 'components/Trade/Proposal';

export default {
  component: Proposal,
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
    team: {
      id: '1',
      name: 'Cincinnati Reds',
      logo: 'logos/reds.svg',
      level: 'MLB',
      city: 'Cincinnati'
    },
    assets: [
      {
        id: '1',
        name: 'Shawn Lewis',
        position: 'SP',
        type: 'Player',
        team: {
          id: '1',
          name: 'Cincinnati Reds',
          logo: 'logos/reds.svg',
          level: 'MLB',
          city: 'Cincinnati'
        },
        overallRating: 3.5,
        potentialRating: 4
      },
      {
        id: '2',
        name: 'Rod Griffin',
        position: 'CF',
        type: 'Player',
        team: {
          id: '100',
          name: 'Poland Whiskeyjacks',
          logo: 'logos/reds.svg',
          level: 'A-',
          city: 'Poland'
        },
        overallRating: 3.5,
        potentialRating: 4
      },
      {
        type: 'Cash',
        amount: 5000000
      }
    ]
  },
  recipient: {
    team: {
      id: '2',
      name: 'New York Mets',
      logo: 'logos/mets.svg',
      level: 'MLB',
      city: 'New York'
    },
    assets: [
      {
        id: '4',
        name: 'Myron Vazquez',
        position: 'RF',
        type: 'Player',
        team: {
          id: '2',
          name: 'New York Mets',
          logo: 'logos/mets.svg',
          level: 'MLB',
          city: 'New York'
        },
        overallRating: 3.5,
        potentialRating: 4
      },
      {
        type: 'DraftPick',
        round: 1,
        year: 2053,
        originalTeam: {
          id: '3',
          name: 'Boston Red Sox',
          logo: 'logos/red_sox.svg',
          level: 'MLB',
          city: 'Boston'
        }
      }
    ]
  }
};

export const AcceptedTradeProposal = () => {
  return <Proposal {...proposalData} />;
};
