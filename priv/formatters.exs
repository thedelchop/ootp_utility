[
  {
    ~r/^(\d-\d):\sFoul\sBall,\s\(location:\s2F\)$/,
    (fn 
      _, count ->
        "#{count}: Strike (Foul Ball, 2F)"
    end)
  },
  {
    ~r/^(\d-\d):\sCalled\sStrike$/,
    (fn 
      _, count ->
        "#{count}: Strike (Looking)"
    end)
  }
]
