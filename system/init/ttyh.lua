log("You have reached the offices of ttyh.lua, please stand by.")
if component.list("gpu")() ~= nil and component.list("screen")() ~= nil then
 -- screen init
 log("GPU and screen found!")
 local ttytab = {}
 ttytab.gpu = {}
 ttytab.w,ttytab.h=0,0 -- resolution
 ttytab.cx,ttytab.cy = 1,1 -- current x and y
 local function gpu_init()
  ttytab.gpu=component.proxy(component.list("gpu")())
  ttytab.gpu.bind(component.list("screen")())
  ttytab.w, ttytab.h = ttytab.gpu.getResolution()
  ttytab.gpu.setResolution(ttytab.w,ttytab.h)
  ttytab.gpu.setBackground(0x000000)
  ttytab.gpu.setForeground(0xFFFFFF)
  ttytab.gpu.fill(1,1,ttytab.w,ttytab.h," ")
  ttytab.gpu.set(1,1,"█")
 end
 gpu_init()
 log("Terminal initialized.")
 event.listen("writeterm",function(_,char)
  if char == nil then log("Nope.") return end
  if char == "\n" then
   ttytab.gpu.set(ttytab.cx,ttytab.cy," ")
   ttytab.cx,ttytab.cy = 1,ttytab.cy+1 -- go to next line, return to start of line
   log("newline!")
  elseif char == "\r" then
   ttytab.gpu.set(ttytab.cx,ttytab.cy," ")
   ttytab.cx = 1 -- return to start of line
   log("return!")
  elseif char == "\b" then
   if ttytab.cx > 1 then
    ttytab.cx = ttytab.cx - 1
--    ttytab.gpu.set(ttytab.cx,ttytab.cy,"█ ")
   end
   log("backspace!")
  elseif char == "\f" then
   ttytab.cx,ttytab.cy = 1,1
   gpu_init()
  else
   log("Writing "..char.." (".. tostring(string.byte(char)) .. ") to location "..ttytab.cx..","..ttytab.cy)
--   ttytab.gpu.set(ttytab.cx,ttytab.cy,char.."█")
   ttytab.gpu.set(ttytab.cx,ttytab.cy,char)
   ttytab.cx = ttytab.cx + 1
   log("wrote "..char.. " " .. tostring(string.byte(char)))
  end
 end)
 event.listen("writeln",function(_,str)
  log("Writing "..str)
  local strtab = string.chars(str.."\n")
  for k,v in pairs(strtab) do
   event.push("writeterm",v)
  end
  log("Finished writing!")
 end)
 writeln("test\ntest2\b\ra")
 writeln(tostring((computer.totalMemory()-computer.freeMemory())/1024).. "\ntest\b\ntest\ra")
 event.push("writeterm","a")
end
