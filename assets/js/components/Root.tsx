import React, { FunctionComponent } from 'react';
import {Grid, Paper} from '@material-ui/core';
import { LeagueStandings} from 'components/Standings'

const league = {
  name: 'Major League Sim Baseball',
  conference_standings: [
    {
      name: 'American League',
      division_standings: [
        {
          name: 'AL East',
          team_records: [
            {
              name: 'Boston Red Sox',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              },
            },
            {
              name: 'Toronto Blue Jays',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Baltimore Orioles',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'New York Yankees',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Tampa Bay Rays',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            }
          ]
        },
        {
          name: 'AL Central',
          team_records: [
            {
              name: 'Minnesota Twins',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              },
            },
            {
              name: 'Chicago White Sox',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Cleveland Indians',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Kansas City Royals',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Detroit Tigers',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            }
          ]
        },
        {
          name: 'AL West',
          team_records: [
            {
              name: 'Houston Astros',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              },
            },
            {
              name: 'Los Angeles Angels',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Texas Rangers',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Seattle Mariners',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Oakland Athletics',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            }
          ]
        },

      ]
    },
    {
      name: 'National League',
      division_standings: [
        {
          name: 'NL East',
          team_records: [
            {
              name: 'Atlanta Braves',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              },
            },
            {
              name: 'Washington Nationals',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'New York Mets',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Philadelphia Phillies',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Miami Marlins',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            }
          ]
        },
        {
          name: 'NL Central',
          team_records: [
            {
              name: 'Chicago Cubs',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              },
            },
            {
              name: 'St. Louis Cardinals',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Pittsburgh Pirates',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Cincinnati Reds',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Milwaukee Brewers',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            }
          ]
        },
        {
          name: 'NL West',
          team_records: [
            {
              name: 'Los Angeles Dodgers',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              },
            },
            {
              name: 'San Diego Padres',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Colorado Rockies',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'Arizona Diamondbacks',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            },
            {
              name: 'San Francisco Giants',
              record: {
                wins: 81,
                losses: 81,
                winning_percentage: 0.500,
                games_behind: 6,
                streak: 4,
                magic_number: 3,
                games: 162
              }
            }
          ]
        }
      ]
    }
  ]
}

const Root: FunctionComponent = () => (
  <Grid>
    <Paper><LeagueStandings {...league} /></Paper>
  </Grid>
);

export default Root;
