export type Position = 'SP' | 'C' | '1B' | '2B' | '3B' | 'SS' | 'LF' | 'CF' | 'RF' | 'DH';
export type Level = 'MLB' | 'AAA' | 'AA' | 'A' | 'A-' | 'R';
export type PlayerRating = 0.5 | 1 | 1.5 | 2 | 2.5 | 3 | 3.5 | 4 | 4.5 | 5;
export type PlayerRatingType = 'Actual' | 'Potential';

export interface TradeAsset {
  id: string;
  name: string;
  position: Position;
  team: string;
  level: Level;
  overallRating: PlayerRating;
  potentialRating: PlayerRating;
}

export interface TeamOffering {
  name: string;
  logo: string;
  assets: TradeAsset[];
}

export interface TradeProposal {
  initiator: TeamOffering;
  recipient: TeamOffering;
}
