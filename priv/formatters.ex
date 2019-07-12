[
  {
    ~r/^(\d-\d):\sFoul\sBall,\slocation:\s([1-9]{0,2}[A-Z]{0,3})$/,
    (fn 
      _, count, location ->
        "#{count}: Strike (Foul Ball, #{location})"
    end)
  },
  {
    ~r/(\d-\d): Bunted foul/,
    (fn
      _, count ->
        "#{count}: Strike (Foul Ball, 2F)"
    end)
  },
  {
    ~r/^(\d-\d):\s(Called|Swinging)\sStrike$/,
    (fn 
      _, count, type ->
        "#{count}: Strike (#{type})"
    end)
  },
  {
    ~r/^(\d-\d):\sBall$/,
    (fn 
      _, count ->
        "#{count}: Ball"
    end)
  },
  {
    ~r/^(\d-\d):\sStrikes\sout\s+swinging(?:\s(passed\sball|wild\spitch),\sreaches\sfirst!|(?:,\s([1-9]-[1-9])\sout\sat\sfirst.))?$/,
    (fn 
      _, count, "", "" ->
        "#{count}: Strikeout (Swinging)"
      _, count, event, "" ->
        "#{count}: Strikeout (Swinging), {Batter to 1B on #{event}}"
      _, count, "", scoring ->
        "#{count}: Strikeout (Swinging), #{scoring}, {Batter 1B attempt}"
    end)
  },
  {
    ~r/^(\d-\d):\sStrikes\sout\s+looking(\sand\she\s(?:physically\s)?ARGUES\sTHE\sCALL\sAND\sIS\sTOSSED!)?$/,
    (fn
      _, count, "" ->
        "#{count}: Strikeout (Looking)"
      _, count, _ejected ->
        "#{count}: Strikeout (Looking), <Batter ejected>"
    end)
  },
  {
    ~r/^(\d-\d):\s+Fly\sout,\s(F[1-9])\s+\((Popup|Flyball|Line\sDrive),\s([1-9]{0,2}[A-Z]{0,3})\)$/,
    (fn
      _, count, scoring, contact_type, location ->
        "#{count}: Fly out, #{scoring}, (#{contact_type}, #{location})"
    end)
  },
  {
    ~r/^(\d-\d):\s+Grounds?\sout,?\s([1-9,U]-*[1-9]*-*[1-9]*)\s+\(Groundball,\s([1-9]{0,2}[A-Z]{0,3})\)$/,
    (fn
      _, count, scoring, location ->
        "#{count}: Ground out, #{scoring}, (Groundball, #{location})"
    end)
  },
  {
    ~r/^(\d-\d):\s+(\d-RUN|SOLO|GRAND\sSLAM)\sHOME\sRUN\s+\((Flyball|Line Drive),\s([1-9]{0,2}[A-Z]{0,3})\),?\s(?:(?:Distance\s:\s([0-9]{3})\sft)|(?:\((Inside\sthe\sPark)\)))$/,
    (fn
      _, count, runs_scored, type, location, "", "Inside the Park" ->
        runs = case runs_scored do
          "SOLO" -> 1
          "2-RUN"-> 2
          "3-RUN" -> 3
          "GRAND SLAM" -> 4
        end

        "#{count}: Home Run, #{runs}R, (#{type}, #{location}, Inside the Park)"
      _, count, runs_scored, type, location, distance, _ ->
        runs = case runs_scored do
          "SOLO" -> 1
          "2-RUN"-> 2
          "3-RUN" -> 3
          "GRAND SLAM" -> 4
        end

        "#{count}: Home Run, #{runs}R, (#{type}, #{location}, #{distance} ft)"
    end)
  },
  {
    ~r/^(\d-\d):\s+(SINGLE|DOUBLE|TRIPLE)\s+\((Groundball|Flyball|Line\sDrive|Popup),\s([1-9]{0,2}[A-Z]{0,3})\)(?:\s\(infield\shit\))?(?:\s-\sOUT\sat\s(first|second|third|home)\sbase\strying\sto\sstretch\shit\.)?$/,
    (fn
      _, count, scoring, contact_type, location, "" ->
       "#{count}: #{String.capitalize(scoring)}, (#{contact_type}, #{location})" 

      _, count, scoring, contact_type, location, "first" ->
       "#{count}: #{String.capitalize(scoring)}, (#{contact_type}, #{location}), [1B]" 

      _, count, scoring, contact_type, location, "second" ->
       "#{count}: #{String.capitalize(scoring)}, (#{contact_type}, #{location}), [2B]" 

      _, count, scoring, contact_type, location, "third" ->
       "#{count}: #{String.capitalize(scoring)}, (#{contact_type}, #{location}), [3B]" 

      _, count, scoring, contact_type, location, "home" ->
       "#{count}: #{String.capitalize(scoring)}, (#{contact_type}, #{location}), [HOME]" 
    end)
  },
  {
    ~r/^(\d-\d):\s+SINGLE\s+\(Groundball,\s([1-9]{0,2}[A-Z]{0,3})\)\s-\srunner\sOUT\sbeing\shit\sby\sbatted\sball\.(?:\s\(infield\shit\))?$/,
    (fn
      _, count, location ->
        "#{count}: Single, (Groundball, #{location}) {Runner out, hit by batted ball}"
    end)
  },
  {
    ~r/^(\d-\d):\s+Bunt\sfor\shit\sto\s([A-Z,1-9]{1,3})\s-\splay\sat\sfirst,\sbatter\s(safe|OUT)!\s*([1-9]-[1-9])?$/,
      (fn 
        _, count, location, "safe", "" ->
          "#{count}: Single, (Groundball, #{location})"

        _, count, location, "OUT", scoring ->
          "#{count}: Ground out, #{scoring}, (Groundball, #{location})"
      end)
  },
  {
    ~r/^(\d-\d):\sGrounds\sinto\s(?:double|DOUBLE)\splay,\s(U?(\d)-\d(?:-\d)?)(?:\s\(Groundball,\s([1-9]{0,2}[A-Z]{0,3})\))?$/,
    (fn
      _, count, scoring, possible_location, "" ->
        "#{count}: Ground out, #{scoring} (DP), (Groundball, #{possible_location})"
      _, count, scoring, _possible_location, location ->
        "#{count}: Ground out, #{scoring} (DP), (Groundball, #{location})"
    end)
  },
  {
    ~r/^(\d-\d):\sBase\son\sBalls$/,
    (fn
      string, _ -> string 
    end)
  },
  {
    ~r/^(\d-\d):\sIntentional\sWalk$/,
    (fn 
      _, count -> 
        "#{count}: Base on Balls (Intentional)" 
    end)
  },
  {
    ~r/^(\d-\d):\sFielders\sChoice\s(?:attempt\s)?at\s(\d(?:nd|rd|st)|home),\s(Runner\sSAFE.\s)?(U?\d-?\d?)\s\(Groundball,\s([A-Z,1-9]{1,3})\)$/,
    (fn
      _, count, "home", _runner_outcome, scoring, location ->
        "#{count}: Single, #{scoring} (Groundball, #{location}), {Runner safe at home on FC attempt}"
      _, count, "1st", "", scoring, location ->
        "#{count}: Ground out, #{scoring} (FC, 1B), (Groundball, #{location})"
      _, count, "2nd", "", scoring, location ->
        "#{count}: Ground out, #{scoring} (FC, 2B), (Groundball, #{location})"
      _, count, "3rd", "", scoring, location ->
        "#{count}: Ground out, #{scoring} (FC, 3B), (Groundball, #{location})"
    end)
  },
  {
    ~r/^(\d-\d):\sBunt\smissed!$/,
    (fn 
      _, count ->
        "#{count}: Strike (Swinging) [Bunt]"
    end)
  },
  {
    ~r/^(\d-\d):\sHit\sby\sPitch(.*)$/,
    (fn
      _, count, "" ->
        "#{count}: HBP" 
      _, count, _charges_mound ->
        "#{count}: HBP {Batter charges mound, benches clear}" 
    end)
  },
  {
    ~r/^(\d-\d):\s+Reached\son\serror,\s(E[1-9])\s\((Line\sDrive|Popup|Groundball|Flyball),\s([1-9]{0,2}[A-Z]{0,3})\)$/,
    fn string, _ -> string end
  },
  {
    ~r/^(\d-\d):\s+Grounds\sinto\sfielders\schoice\s([1-9,U]-*[1-9]*-*[1-9]*)\s\(Groundball,\s([1-9]{0,2}[A-Z]{0,3})\)$/,
    (fn 
      _, count, scoring, location ->
        "#{count}: Ground out, #{scoring} (FC, Home), (Groundball, #{location})"
    end)
  },
  {
    ~r/^(\d-\d):\sReached\svia\serror\son\sa\sdropped\sthrow\sfrom\s(\d?[A-Z]*),\sE(\d)\s\(Groundball,\s([1-9]{0,2}[A-Z]{0,3})\)$/,
    (fn
      _, count, thrower, error_position, location ->
        import OOTPUtility.Utilities

        {:ok, receiver} = position_from_scoring_key(error_position)
        {:ok, thrower_scoring} = scoring_key_from_position(thrower)
        scoring = "#{thrower_scoring}-#{error_position}"

        "#{count}: Reached on error by #{receiver}, #{scoring} (E#{error_position}), (Groundball, #{location})"
    end)
  },
  {
    ~r/^(\d-\d):\sSac\sBunt\s(?:to\s([1-9]{0,3}[A-Z]?)\s)?-\splay\sat\s(first|second|third),\s(?:batter|runner)\s(OUT|safe)(?:\s-&gt;\sthrow\sto\s(first|second|third|home),\sDP)?!(?:\s([1-9,U]-*[1-9]*-*[1-9]*))?$/,
    (fn
      _, count, "", "second", _outcome, "first", "" ->
        "#{count}: Ground out, 2-6-3 (DP), (Groundball, 2L)"
      _, count, location, _base, "safe", "", _scoring ->
        "#{count}: Single, (Groundball, #{location}) [Bunt]"
      _, count, location, "first", "OUT", "", scoring ->
        "#{count}: Ground out, #{scoring} (FC, 1B), (Groundball, #{location}), [SH]"
      _, count, location, base, "OUT", "", scoring ->
        import OOTPUtility.Utilities
        {:ok, position} = position_from_base(base)

        "#{count}: Ground out, #{scoring} (FC, #{position}), (Groundball, #{location}), [Bunt]"
    end)
  },
  {
    ~r/^(\d-\d):\sBunt\s-\sFlyout\sto\s([1-9]{0,2}[A-Z]{0,3})(?:\s-\sDP\sat\s(first|second|third))?!?\s([1-9,U,F]-*[1-9]*-*[1-9]*)$/,
    (fn 
      _, count, location, "", scoring ->
        "#{count}: Fly out, #{scoring}, (Popup, #{location}), [Bunt]"
      _, count, location, double_play_location, scoring ->
        import OOTPUtility.Utilities

        {:ok, double_play_base} = position_from_base(double_play_location)

        "#{count}: Fly out, #{scoring} (DP, #{double_play_base}), (Popup, #{location}), [Bunt]"
    end)
  },
  {
    ~r/^(\d-\d):\sSingle,\sError\sin\sOF,\s(E[1-9]),\sbatter\sto\ssecond\sbase\s\((Groundball|Line Drive),\s([1-9]{0,2}[A-Z]{0,3})\)$/,
    (fn
      _, count, error, contact_type, location ->
        "#{count}: Single, (#{contact_type}, #{location}), {Batter to 2B on #{error}}"
    end)
  },
  {
    ~r/^(\d-\d):\sSqueeze\sBunt\sto\s([1-9]{0,2}[A-Z]{0,3})\s-\splay\s(?:at\s)?(home|first),\srunner\s(OUT|scores),\sbatter\s(safe|OUT)!\s?([1-9,U,F]-*[1-9]*-*[1-9]*)?$/,
    (fn
      # Sacrifice Bunt
      _, count, location, play_location, "scores", "OUT", scoring ->
        import OOTPUtility.Utilities
        {:ok, position} = position_from_base(play_location)

        "#{count}: Ground out, #{scoring} (FC, #{position}), (Groundball, #{location}), [SH], {Runner from 3B scores}"

      # Fielder's Choice
      _, count, location, play_location, "OUT", "safe", scoring ->
        import OOTPUtility.Utilities
        {:ok, position} = position_from_base(play_location)

        "#{count}: Ground out, #{scoring} (FC, #{position}), (Groundball, #{location}), [Bunt]"
      # Single
      _, count, location, _play_location, "scores", "safe", _scoring ->
        "#{count}: Single, (Groundball, #{location}), [Bunt], {Runner from 3B scores}"
    end)
  },
  {
    ~r/^(\d-\d): Reaches on Catchers interference$/,
    (fn 
      text -> text
    end)
  },
  {
    ~r/^(\d-\d):\sLines\sinto\sTRIPLE\splay,\s([1-9,U,F]-*[1-9]*-*[1-9]*)\s\((Line Drive|Groundball|Popup|Flyball),\s([1-9,U,F]-*[1-9]*-*[1-9]*)\)$/,
    (fn 
      _, count, scoring, contact_type, location ->
        "#{count}: Fly out, #{scoring} (TP), (#{contact_type}, #{location})"
    end)
  },
  {
    ~r/^(.+)\s(?:to\s(second|third)|(scores))$/,
    (fn
      _, player, base, "" ->
        import OOTPUtility.Utilities
        {:ok, position} = position_from_base(base)

        "#{player} to #{position}"
      string, _player, "", "scores" -> string
    end)
  },
  {
    ~r/^(.+)\sis\scaught\sstealing\s(\d)(?:nd|rd)\sbase\s(2-[4-6])$/,
    (fn 
      _, player, base, scoring ->
        "#{player}: CS [#{base}B], #{scoring}"
    end)
  },
  {
    ~r/^(.+)\ssteals\s(\d)(?:nd|rd)(?:\sbase)?(?:,\sthrowing\serror,\s(E\d))?(?:\s\(no\sthrow\))?$/,
    (fn 
      _, player, base, "" ->
        "#{player}: SB [#{base}B]"

      _, player, base, error ->
        "#{player}: SB [#{base}B], #{error}"
    end)
  },
  {
    ~r/^Steal\sof\shome,\s(.+)\sis\s(safe|out)$/,
    (fn 
      _, player, "safe" ->
        "#{player}: SB [Home]"
      _, player, "out" ->
        "#{player}: CS [Home], 1-2"
    end)
  },
  {
    ~r/Wild Pitch!/,
    fn _ -> "WP" end
  },
  {
    ~r/^Throwing\serror,\s(E\d)$/,
    fn _, error -> "#{error} (throw)" end
  }
]
