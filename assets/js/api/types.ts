export type Position = 'SP' | 'C' | '1B' | '2B' | '3B' | 'SS' | 'LF' | 'CF' | 'RF' | 'DH';
export type Level = 'MLB' | 'AAA' | 'AA' | 'A' | 'A-' | 'R';
export type PlayerRating = 0.5 | 1 | 1.5 | 2 | 2.5 | 3 | 3.5 | 4 | 4.5 | 5;
export type PlayerRatingType = 'Actual' | 'Potential';
export type Cash = number;

export interface Team {
  id: string;
  name: string;
  logo: string;
  city: string;
  level: Level;
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
}

export type TradeAsset = Player | DraftPick | Cash;

export interface TeamOffer {
  team: Team;
  assets: TradeAsset[];
}

export interface TradeProposal {
  initiator: TeamOffer;
  recipient: TeamOffer;
}
