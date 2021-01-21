-------------------------------------------------
--			  _    _ _       _____ 
--			 | |  | | |     / ____|
--			 | |  | | |    | (___  
--			 | |  | | |     \___ \ 
--			 | |__| | |____ ____) |
--			  \____/|______|_____/ 
--
-------------------------------------------------
--
--	               Whitelist
--					 v1.0a
--           Usual_Light - Gs_ck
-------------------------------------------------
local whitelistMode = "public"
local list = {426184920, 426187622}
local intable = function(array,item) 
	for index = 1,#array do 
		if array[index] == item then 
			return true
		end
	end
	return false
end

if whitelistMode == "public" then
	for i = 1, 10 do
		warn("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		warn("DESK IS IN PUBLIC MODE")
		warn("CLIENT IS BEING SENT TO EVERYONE.")
		warn("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	end
end

return function(id)
	if whitelistMode == "public" then
		return true
	end
	
	if typeof(id) == "Instance" and id:IsA("Player") then 
		return intable(list,id.UserId)
	end
	return intable(list,id)
end
