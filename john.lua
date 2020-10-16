
SILE.registerCommand("chapter", function(options, content)
  SILE.call("bible:chapter-head",{},{options.number})
  SILE.call("save-chapter-number",{},{options.number})
end)

SILE.registerCommand("verse", function(options,content)
  SILE.call("verse-number", options, {options.number})
end)

local pdf = require("justenoughlibtexpdf")

SILE.registerCommand("frame-rule", function(options, content)
  local width = 0.8
  local offset = 10
  local f = SILE.getFrame("content")
  --pdf.colorpush(0.8,0,0)
  SILE.outputter:drawRule(f:left()-offset, f:top()-offset, f:width()+2*offset, width)
  SILE.outputter:drawRule(f:left()-offset, f:top()-offset, width, f:height()+2*offset)
  SILE.outputter:drawRule(f:right()+offset, f:top()-offset, width, f:height()+2*offset)
  SILE.outputter:drawRule(f:left()-offset, f:bottom()+offset, f:width()+2*offset, width)
  --pdf.colorpop()
end)

SILE.typesetter:registerHook("pageend", function ()
  SILE.call("frame-rule")
end)

SILE.documentState.documentClass.pageTemplate.frames["content"].direction = "RTL"
SILE.scratch.masters["right"].frames["content"].direction = "RTL"
SILE.scratch.masters["left"].frames["content"].direction = "RTL"
SILE.call("thisframeRTL")

-- SILE.registerCommand("bible:verse-number", function(options,content)
--     local foo = ""
--     for i in SU.utf8codes(tostring(content[1])) do 
--         foo = SU.utf8char(i-48+0x6f0)..foo
--     end
--     foo = foo .. SU.utf8char(0x6dd)
--     SILE.typesetter:typeset(foo)
-- end)

SILE.registerCommand("bible:verse-number", function(options,content)
  SILE.call("font",{family="Gentium Plus"}, content)
end)
