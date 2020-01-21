import React from 'react';
import { host } from 'storybook-host';

import Proposal from 'components/Trade/Proposal';
import proposalData from 'components/Trade/Proposal.data';

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

export const PendingTradeProposal = () => {
  return <Proposal {...proposalData} />;
};

export const AcceptedTradeProposal = () => {
  return <Proposal acceptedAt={new Date(2053, 0, 18)} {...proposalData} />;
};
