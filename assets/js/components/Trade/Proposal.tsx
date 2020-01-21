import React, { useState, FunctionComponent, MouseEventHandler } from 'react';
import { format as formatDate } from 'date-fns';

import {
  Avatar,
  Button,
  Card,
  CardActions,
  CardContent,
  CardHeader,
  Collapse,
  Divider,
  IconButton,
  Typography
} from '@material-ui/core';
import { ExpandMore, ExpandLess } from '@material-ui/icons';
import { makeStyles } from '@material-ui/styles';
import { AvatarGroup } from '@material-ui/lab';

import { TradeProposal } from 'api/types';
import TeamOffer from 'components/Trade/TeamOffer';

type TradeProposalSubheaderProps = Pick<TradeProposal, 'proposedAt' | 'acceptedAt'>;

const TradeProposalSubheader: FunctionComponent<TradeProposalSubheaderProps> = ({ proposedAt, acceptedAt }) => {
  const actionVerb = acceptedAt ? 'Accepted' : 'Proposed';
  const date = formatDate(acceptedAt ? acceptedAt : proposedAt, 'MMMM d, yyyy');

  return (
    <Typography variant="body1" color="textSecondary" display="inline">
      {actionVerb} on {date}
    </Typography>
  );
};

interface TradeProposalHeaderProps extends TradeProposal {
  onClick: MouseEventHandler;
  open: boolean;
}

const TradeProposalHeader: FunctionComponent<TradeProposalHeaderProps> = ({
  initiator,
  recipient,
  acceptedAt,
  proposedAt,
  onClick,
  open
}) => {
  const {
    team: { city: initiatorName }
  } = initiator;
  const {
    team: { city: recipientName }
  } = recipient;

  return (
    <CardHeader
      disableTypography
      avatar={
        <AvatarGroup>
          <Avatar style={{ border: 0, left: 8, bottom: 16 }} variant="square" src={initiator.team.logo} />
          <Avatar style={{ border: 0, left: 8, top: 16 }} variant="square" src={recipient.team.logo} />
        </AvatarGroup>
      }
      action={
        <IconButton aria-label="expand" onClick={onClick}>
          {open ? <ExpandLess /> : <ExpandMore />}
        </IconButton>
      }
      title={
        <Typography variant="h5">
          {initiatorName} &#8210; {recipientName}
        </Typography>
      }
      subheader={<TradeProposalSubheader proposedAt={proposedAt} acceptedAt={acceptedAt} />}
    />
  );
};

const TradeProposalCard: FunctionComponent<TradeProposal> = (props) => {
  const { initiator, recipient, acceptedAt } = props;
  const [open, setOpen] = useState(!acceptedAt);

  const cardStyles = makeStyles({
    root: { width: 525 }
  })();

  const renderButtons = () => (
    <CardActions>
      <Button size="medium" color="secondary">
        Reject
      </Button>
      <Button size="medium" color="primary">
        Accept
      </Button>
    </CardActions>
  );

  return (
    <Card classes={cardStyles} raised>
      <TradeProposalHeader {...props} onClick={() => setOpen(!open)} open={open} />
      <Collapse in={open} timeout="auto" unmountOnExit>
        <CardContent>
          <TeamOffer {...initiator} />
          <Divider variant="middle" />
          <TeamOffer {...recipient} />
        </CardContent>
      </Collapse>
      {!acceptedAt && renderButtons()}
    </Card>
  );
};

export default TradeProposalCard;
