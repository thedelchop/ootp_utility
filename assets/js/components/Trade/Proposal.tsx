import React, { useState, FunctionComponent } from 'react';

import { Card, CardContent, CardHeader, Collapse, Divider, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/core/styles';
import { ExpandMore, ExpandLess } from '@material-ui/icons';

import { TradeProposal } from 'api/types';
import TeamOffer from 'components/Trade/TeamOffer';

const useStyles = makeStyles({ card: { width: 500 } });

const TradeProposalCard: FunctionComponent<TradeProposal> = ({ initiator, recipient }) => {
  const [open, setOpen] = useState(true);
  const classes = useStyles();

  return (
    <Card classes={{ root: classes.card }} raised>
      <CardHeader
        action={
          <IconButton aria-label="expand" onClick={() => setOpen(!open)}>
            {open ? <ExpandLess /> : <ExpandMore />}
          </IconButton>
        }
        title="Boston - Cincinnati"
        subheader="December 29, 2052"
      />
      <Collapse in={open} timeout="auto" unmountOnExit>
        <CardContent>
          <TeamOffer {...initiator} />
          <Divider variant="middle" />
          <TeamOffer {...recipient} />
        </CardContent>
      </Collapse>
    </Card>
  );
};

export default TradeProposalCard;
