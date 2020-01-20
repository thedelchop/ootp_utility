import React, { FunctionComponent } from 'react';
import { ListItemText, Typography } from '@material-ui/core';
import { DraftPick } from 'api/types';
import TradeAssetContainer from 'components/TradeAsset/Container';

const toOrdinal = (num: number): string => {
  const digits = [num % 10, num % 100],
    ordinals = ['st', 'nd', 'rd', 'th'],
    oPattern = [1, 2, 3, 4],
    tPattern = [11, 12, 13, 14, 15, 16, 17, 18, 19];
  return oPattern.includes(digits[0]) && !tPattern.includes(digits[1])
    ? num + ordinals[digits[0] - 1]
    : num + ordinals[3];
};

interface SecondaryTextProps {
  year: number;
  teamName: string;
}

const SecondaryText: FunctionComponent<SecondaryTextProps> = ({ year, teamName }) => (
  <Typography variant="overline" color="textSecondary" display="inline">
    {year} | {teamName}
  </Typography>
);

const DraftPickTradeAsset: FunctionComponent<DraftPick> = ({
  year,
  round,
  originalTeam: { name: originalTeamName }
}) => (
  <TradeAssetContainer>
    <ListItemText
      inset
      primary={<Typography variant="body1">{toOrdinal(round)} Round Draft Pick</Typography>}
      secondary={<SecondaryText year={year} teamName={originalTeamName} />}
    />
  </TradeAssetContainer>
);

export default DraftPickTradeAsset;
