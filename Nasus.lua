--[[ Welcome to Wodian's Nasus 
Copyright and Credits are going to the respective owners of some part of the code.

Changelog:
v1.0 -- Release Version
]]--
if myHero.charName ~= "Nasus" then return end

require "SxOrbWalk"

local range = 1000
local ts = TargetSelector(TARGET_LOW_HP_PRIORITY, range, DAMAGE_PHYSICAL, false)
local ERange, WRange = 600, 650
local killedcount, QBonus = 0, 0
local qRange = 175
local Stacks = 0

function OnLoad()
				print("<font color='#FFFFFFF'>Welcome to Wodian's Nasus.</font> <font color='#FFFFF00'>Now Carry from the Toplane!</font>")
				print("<font color='#FFFFFFF'>Your Version is v1.0 Enjoy!</font>")
				LoadMenu()
end

function OnTick()
ts:update()
farm()
Combo()
R()
if ts.target == nil and Config.combo.combo then myHero:MoveTo(mousePos.x, mousePos.z) end
end

local dontCancel = false

function farm()
if Config.farm then 
	for _, minion in pairs(minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_HEALTH_ASC).objects) do
		local qDmg = getDmg("Q", minion, myHero)
		if GetDistance(minion, myHero) <= 175 and SxOrb:CanMove() then 
			if CanCast(_Q) and minion.health < (qDmg + myHero.totalDamage + Stacks) then
				if SxOrb:CanMove() then
				CastSpell(_Q)
				myHero:Attack(minion)
				end
			end
		end
		if SxOrb:CanMove() then myHero:MoveTo(mousePos.x, mousePos.z) end
end
end
end

function LoadMenu()				
		Config = scriptConfig("Wodian's Nasus", "Nasus")
			Config:addSubMenu("Combo Settings", "combo")
				Config.combo:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
				Config.combo:addParam("useW", "Use W in combo", SCRIPT_PARAM_ONOFF, true)
				Config.combo:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
				Config.combo:addParam("useR", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
				Config.combo:addParam("combo", "Combo!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
				
			Config:addSubMenu("Draw Settings", "draw")
				Config.draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
				Config.draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
				Config.draw:addParam("drawLH", "Draw Lasthits", SCRIPT_PARAM_ONOFF, true)
			Config:addParam("farm", "Auto Q Farm", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
			Config:addParam("lifesaver", "Auto Ult at 20% HP", SCRIPT_PARAM_ONOFF, true)
			SxOrb:LoadToMenu(Config.SxOrb)
end

function R()
	if Config.lifesaver and CanCast(_R) then
		if myHero.health < myHero.maxHealth*0.2 then
		CastSpell(_R)
		end
	end
end


function Combo()
	if Config.combo.combo and ts.target then
		if CanCast(_W) and GetDistance(ts.target) <= WRange then 
		CastSpell(_W, ts.target) 
		end
		if CanCast(_E) and GetDistance(ts.target) <= ERange then 
		CastSpell(_E, ts.target) 
		end
		if CanCast(_Q) and GetDistance(ts.target) <= qRange then 
		CastSpell(_Q) 
		myHero:Attack(ts.target)
		end 
		if myHero.health < myHero.maxHealth*0.6 and CanCast(_R) and Config.combo.useR then
		CastSpell(_R) 
		end
		if not CanCast(_Q) then
			if GetDistance(ts.target) <= qRange then
				myHero:Attack(ts.target)
			end
		end
    end
end 

function OnDraw()
	for _, minion in pairs(minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_HEALTH_ASC).objects) do
		local qDmg = getDmg("Q", minion, myHero)
			if GetDistance(minion) <= 1200 and minion.health < (qDmg + myHero.totalDamage + Stacks) and Config.draw.drawLH then DrawCircle(minion.x, minion.y, minion.z, 125, 0xFFFF0000) 
			end
		end	
	if CanCast(_E) and Config.draw.drawE then
		DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x111111)
	end
	if CanCast(_W) and Config.draw.drawW then
		DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x444444)
	end
end

function CanCast(Spell)
return (player:CanUseSpell(Spell) == READY)
end

function OnCreateObj(obj)
	Stacks = Stacks
	 if obj.name == "DeathsCaress_nova.troy" then Stacks = Stacks + 3 end
end