[
  {
    ~r/^(\d-\d):\sFoul\sBall,\s\(location:\s2F\)$/,
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
    ~r/^(\d-\d):\sStrikes\sout\sswinging$/,
    (fn 
      _, count ->
        "#{count}: Strikeout (Swinging)"
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
    ~r/^(\d-\d):\s+Ground\sout\s([1-9,U]-*[1-9]*-*[1-9]*)\s+\(Groundball,\s([1-9]{0,2}[A-Z]{0,3})\)$/,
    (fn
      _, count, scoring, location ->
        "#{count}: Ground out, #{scoring}, (Groundball, #{location})"
    end)
  },
  {
    ~r/(\d-\d):\s+(\d-RUN|SOLO|GRAND\sSLAM)\sHOME\sRUN\s+\((Flyball|Line\sDrive),\s([1-9]{0,2}[A-Z]{0,3})\),\sDistance\s:\s([1-9]{3})\sft$/,
    (fn
      _, count, runs_scored, type, location, distance ->
        runs = case runs_scored do
          "SOLO" -> 1
          "2-RUN"-> 2
          "3-RUN" -> 3
          "GRAND SLAM" -> 4
        end

        "#{count}: Home Run, #{runs}R, (#{type}, #{location}, #{distance} ft)"
    end)
  }
]
