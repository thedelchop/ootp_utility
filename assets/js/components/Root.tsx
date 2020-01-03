import React, { FunctionComponent } from 'react';

import { TradeProposal } from 'api/types';

import Proposal from 'components/Trade/Proposal';

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
        level: 'MLB',
        overallRating: 3.5,
        potentialRating: 4
      },
      {
        id: '2',
        name: 'Rod Griffin',
        position: 'CF',
        team: 'Poland Whiskeyjacks',
        level: 'A-',
        overallRating: 3.5,
        potentialRating: 4
      },
      {
        id: '3',
        name: 'Robby Dropo',
        position: 'SP',
        team: 'Sarasota Reds',
        level: 'A',
        overallRating: 3.5,
        potentialRating: 4
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
        level: 'MLB',
        overallRating: 3.5,
        potentialRating: 4
      },
      {
        id: '5',
        name: 'Bud Dailey',
        position: 'SP',
        team: 'Binghamton Mets',
        level: 'AA',
        overallRating: 3.5,
        potentialRating: 4
      }
    ]
  }
};

const Root: FunctionComponent = () => <Proposal {...proposalData} />;

export default Root;
