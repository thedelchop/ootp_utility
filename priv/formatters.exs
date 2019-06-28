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
  }
]
