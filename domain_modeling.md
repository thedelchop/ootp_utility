# Domain Modeling

## Glossary of Terms

<dl>
  <dt>Runner</dt>
    <dd>An offensive player who is currently occupying one of four bases</dd>
  <dt>Batter</dt>
    <dd>The offensive player who is currently making a Plate Appearance (PA)</dd>
  <dt>Pitcher</dt>
    <dd>The defensive player who is currently making an Appearance</dd>
  <dt>Fielder</dt>
  <dd>A defensive player who is currently fielding, catching, or throwing the ball</dd>
</dl>

## Event Diagramming

The `Game.GameLog` is a collection of lines that describe the action of a series of games.  Each line of the game can be processed
to produce an event or series of events that describe the action in a way that can be used to build aggregates, like a `Game.Frame`, or `Game.Inning`, or statistical aggregates like `Statistics.BattingAverage` or `Player.GameStatistics`.

These events are probably best described by being grouped, where they can be, into collections based on the following roles:

* Runner
* Batter
* Pitcher
* Fielder


### Runner Events

* Runner.Advanced
* Runner.ThrownOut
* Runner.StoleBase
* Runner.CaughtStealing
* Runner.TaggedUp
* Runner.Scored

### Batter Events

* Batter.StrikedCalled
* Batter.BallCalled
* Batter.Walked
* Batter.IntentionallyWalked
* Batter.StruckOut
* Batter.HitByPitch
* Batter.Singled
* Batter.Doubled
* Batter.Tripled
* Batter.Homered
* Batter.HitIntoFieldersChoice
* Batter.HitIntoDoublePlay
* Batter.HitIntoTriplePlay
* Batter.GroundedOut
* Batter.LinedOut
* Batter.PoppedOut
* Batter.Bunted
* Batter.HitFoulBall
* Batter.FouledOut

### Pitcher Events

  * Pitcher.StartedFrame
  * Pitcher.MadePickoffAttempt
  * Pitcher.PickedOffRunner
  * Pitcher.ThrewWildPitch
  * Pitcher.Balked
  * Pitcher.MadeAppearance

### Fielder Events

  * Fielder.FieldedBall
  * Fielder.CaughtBall
  * Fielder.ThrewBall
  * Fielder.RecordedPutout
  * Fielder.RecordedAssist
  * Fielder.MadeThrowingError
  * Fielder.MadeFieldingError
  * Fielder.AllowedPastBall



## File Importing

All of the data that we are going to be working with will be coming from OOTP itself.  That data can be imported via two formats, raw SQL and CSV.  Potentialy in the future this may change, but those are the existing formats.

There is a nice bonuded context for my application here, everything that has to do with Importing is its own context, and probably has a couple of different mechanisms we should be using to get the data into my domain.  Here are some of the concepts that, IMO, should only live inside this context.

I have to be careful not to get too focused on the importing of GameLogs, there is a much more general interface here at play, I need to import a whole bunch of different kinds of files,
but there are some common things that are at play:

1) The File itself is going to be stored in a specific format; CSV or SQL for the immediate future.  So we need a common way to get the information stored into a map. This should be specific to the file format, but at the end of the process, the file should be represented as a list of maps, one for each row.
2) The map needs to be translated into a set of attributes that can be passed into an object that understands how to create the final record.
3) This should probably be a factory, but here is probably a good place for a service, something like FileHydrationService or something, where the attributes are passed in and _it_ figures out what should be created.

<dl>
<dt>ImportService</dt>
<dd></dd>

<dt>ImportService.CSVAdapter</dt>
<dd></dd>

<dt>ImportService.SQLAdapter</dt>
<dd></dd>

<dt>ImportService.Translator</dt>
<dd></dd>

<dt>GameLog.LineFactory</dt>
<dd></dd>

<dt>GameLog.LineRepository</dt>
<dd></dd>
</dl>

## GameLog Processing (Event Generation)

<dl>
  <dt>GameLog.EventFactory</dt>
  <dd></dd>
</dl>
