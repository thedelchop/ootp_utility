export type Position = 'SP' | 'C' | '1B' | '2B' | '3B' | 'SS' | 'LF' | 'CF' | 'RF' | 'DH';
export type Level = 'MLB' | 'AAA' | 'AA' | 'A' | 'A-' | 'R';
export type PlayerRating = 0.5 | 1 | 1.5 | 2 | 2.5 | 3 | 3.5 | 4 | 4.5 | 5;
export type PlayerRatingType = 'Actual' | 'Potential';

export interface Team {
  id: string;
  name: string;
  logo: string;
  city: string;
  level: Level;
  abbrev: string;
}

export interface Player {
  id: string;
  name: string;
  position: Position;
  team: Team;
  overallRating: PlayerRating;
  potentialRating: PlayerRating;
}

export interface DraftPick {
  round: number;
  year: number;
  originalTeam: Team;
}

export interface Cash {
  amount: number;
}

export interface CashTradeAsset extends Cash {
  type: 'Cash';
}

export interface DraftPickTradeAsset extends DraftPick {
  type: 'DraftPick';
}

export interface PlayerTradeAsset extends Player {
  type: 'Player';
}

export type TradeAsset = CashTradeAsset | PlayerTradeAsset | DraftPickTradeAsset;

export interface TeamOffer {
  team: Team;
  assets: TradeAsset[];
}

export interface TradeProposal {
  initiator: TeamOffer;
  recipient: TeamOffer;
  acceptedAt?: Date;
  proposedAt: Date;
}
