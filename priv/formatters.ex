[
  {
    ~r/^(\d-\d):\sFoul\sBall,\slocation:\s2F$/,
    (fn 
      _, count ->
        "#{count}: Strike (Foul Ball, 2F)"
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
    ~r/^(\d-\d):\sStrikes\sout\s(swinging|looking)$/,
    (fn 
      _, count, type ->
        "#{count}: Strikeout (#{String.capitalize(type)})"
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
    ~r/^(\d-\d):\s+Bunt\sfor\shit\sto\s([A-Z,1-9]{1,3})\s-\splay\sat\sfirst,\sbatter\s(safe|OUT)!\s*([1-9]-[1-9])?$/,
      (fn 
        _, count, location, "safe", "" ->
          "#{count}: Single, (Groundball, #{location})"

        _, count, location, "OUT", scoring ->
          "#{count}: Ground out, #{scoring}, (Groundball, #{location})"
      end)
  },
  {
    ~r/^(\d-\d):\sGrounds\sinto\s(?:double|DOUBLE)\splay,\s(U?\d-\d(?:-\d)?)\s\(Groundball,\s([1-9]{0,2}[A-Z]{0,3})\)$/,
    (fn
      _, count, scoring, location ->
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
    ~r/^(\d-\d):\sFielders\sChoice\sat\s(\d(?:nd|rd|st)),\s(U?\d-?\d?)\s\(Groundball,\s([A-Z,1-9]{1,3})\)$/,
    (fn
      _, count, "1st", scoring, location ->
        "#{count}: Ground out, #{scoring} (FC, 1B), (Groundball, #{location})"
      _, count, "2nd", scoring, location ->
        "#{count}: Ground out, #{scoring} (FC, 2B), (Groundball, #{location})"
      _, count, "3rd", scoring, location ->
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
    ~r/^(\d-\d):\sHit\sby\sPitch$/,
    fn _, count -> "#{count}: HBP" end
  },
  {
    ~r/^(\d-\d):\s+Reached\son\serror,\s(E[1-9])\s\((Line\sDrive|Popup|Groundball|Flyball),\s([1-9]{0,2}[A-Z]{0,3})\)$/,
    fn string, _ -> string end
  }
]
