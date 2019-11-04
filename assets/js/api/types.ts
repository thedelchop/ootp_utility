export interface TeamRecord {
    id: string;
    games: number;
    games_behind: number;
    losses: number;
    magic_number: number;
    position: number;
    streak: number;
    winning_percentage: number;
    wins: number;
    team?: Team;
};

export interface Team {
  id: string;
  name: string;
  iconURL:string;
  record: TeamRecord;
};

export interface Division {
  id: string;
  name: string;
  teams: Team[];
};

export interface Conference {
  id: string;
  name: string;
  divisions: Division[];
};

export interface League {
  id: string;
  name: string;
  conferences: Conference[];
};
