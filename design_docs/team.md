# Team home page

## Overview

The overlying UI/UX concept I'm working with here is that for all the different information
that I could display, it can be displayed in three format, each revealing different levels of detail:

<dl>
  <dt> Component</dt>
  <dd> The most compact form of the resource, the component is meant to be a part of the larger Team page, it
  can often be thought about as the mobile version of the data display</dd>

  <dt> Panel </dt>
  <dd> A higher level of detail for the resource since the panel will occupy more of the view port and can be
  thought of as the "Tablet" version of the page</dd>

  <dt>Page</dt>
  <dd>The highest level of detail possible, occupying the entire viewport, this can be thought of as the
  equivalent of a full page view.</dd>
</dl>

Some resources will not have all three levels of detail, and on mobile devices and tablets, the panel view
will be treated as a page view as the maximum level of detail on a tablet/mobile screen.


Here is a breakdown of the current components and the different views I hope to implement for each of the
different "resources" for lack of a better term.


| Function     | Component | Panel | Page |
| :----------- | :-------: | :---: | :--: |
| Standings    |    X      |   X   |      |
| Next Game    |    X      |   X   |      |
| Organization |    X      |       |  X   |
| Statistics   |    X      |   X   |  X   |
| Team Stats   |    X      |   X   |      |
| Injuries     |    X      |   X   |      |
| Schedule     |    X      |   X   |  X   |
| Roster       |    X      |   X   |  X   |
| Transactions |    X      |   X   |      |

I'm not sure if I want to offer direct navigation to the "Page" views, I think I prefer the experience of
always drilling down, so arriving at the team page, clicking on some part of a component, seeing a panel, then
choosing finally to navigate to a full page view if required.

If I change my mind, I think that a set of tabs to handle navigation between pages would work great.

## Resource Details

### Standings

#### Component

The component view should just be the division standings component in its mobile view

#### Panel

The Panel view should include the ability to view the division standings, wild card standings and league
standings with the option to view basic/expanded information

### Next Game

#### Component

The "Next Game" component will show the next upcoming game, with the probable starting pitchers

#### Panel 

The "Next Game" panel will try to include the starting lineups for each team and some stats about the two
teams and their respective rankings

### Organization

#### Component

The Organization component will list the current record of each team in the team's organization and their
current position in their respective league/division/conference, whatever the parent is

#### Panel

The panel will break out some more information for each of the teams, include a "Next Game" component, their
team leaders and their team rankings

#### Page

The organization page will list all of the previous information and include a roster for each team

### Player Statistics

#### Component 

The player statistics component will list the team leaders for 2 categories (Hitting/Pitching) in a tabular interface.  
Each category will show the leader for each of 5 categories.

#### Panel 

Expanding to a panel view will render the leaders in a list of cards, each listing a category and the top 5
leaders in that category.

#### Page

The Statistics page will be a full page table for each of the three categories, which will also be able to
expand/collapse sections for detail.

### Team Statistics

### Injuries

### Schedule

### Roster

### Transactions
