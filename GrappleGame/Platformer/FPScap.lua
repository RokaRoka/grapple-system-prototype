--Set frame cap
min_dt = 1/60
next_time = love.timer.getTime()

--Function for keeping an
function setFPSupdate()
	--set the time of the next update
	next_time = next_time + min_dt
end

function setFPSdraw()
  --check the time vs what time should be
	local cur_time = love.timer.getTime()
  if next_time <= cur_time then
    next_time = cur_time
    return
	end
	love.timer.sleep(next_time - cur_time)
end
