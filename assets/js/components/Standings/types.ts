import {TeamRecord as Record} from 'api/types';

export interface TeamRecord {
  name: string;
  record: Omit<Record, 'id' | 'position'>;
};

export interface DivisionStandings {
  name: string;
  team_records: TeamRecord[];
};

export interface ConferenceStandings {
  name: string;
  division_standings: DivisionStandings[];
};

export interface LeagueStandings {
  name: string;
  conference_standings:ConferenceStandings[];
};
