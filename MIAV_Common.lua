MIAV= {}
ONLINEPLAYERLIST = {}
STEAMLIST = {}
IPLIST = {}
PRODLIST = {}
ranklist = {}
ranklist["Owner"] = 250
ranklist["Admin"] = 200
ranklist["Developer"] = 150
ranklist["Moderator"] = 100
ranklist["Regular"] = 50
grouplist = {}
---------------------------------------------------------------------------------------------
function loadALLBANS()
    local loadfile_ip = LoadResourceFile(GetCurrentResourceName(), "banlists/ipBanList.json")
    loadedIP = json.decode(loadfile_ip)
    IPLIST = loadedIP
    local loadfile_steam = LoadResourceFile(GetCurrentResourceName(), "banlists/steamBanList.json")
    loadedSteam = json.decode(loadfile_steam)
    STEAMLIST = loadedSteam
    local loadfile_license = LoadResourceFile(GetCurrentResourceName(), "banlists/prodBanList.json")
    loadedLicense = json.decode(loadfile_license)
    PRODLIST = loadedLicense
    ----------------------------------------------------------------------------
    JustLog("MIA:V - Loaded Data for Banlists")
end
--
function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
--
function Log2File(type, text)
	local gt = os.date('*t')
	local f,err = io.open("MIAV_"..type..".log","a")
	if not f then return print(err) end
	local h = gt['hour'] if h < 10 then h = "0"..h end
	local m = gt['min'] if m < 10 then m = "0"..m end
	local s = gt['sec'] if s < 10 then s = "0"..s end
    local formattedlog = string.format("[%s:%s:%s] %s \n",h,m,s,text)
    Citizen.Trace(formattedlog)
	f:write(formattedlog)
	f:close()
end
--
function JustLog(text)
	local gt = os.date('*t')
	local h = gt['hour'] if h < 10 then h = "0"..h end
	local m = gt['min'] if m < 10 then m = "0"..m end
	local s = gt['sec'] if s < 10 then s = "0"..s end
    local formattedlog = string.format("[%s:%s:%s] %s \n",h,m,s,text)
    Citizen.Trace(formattedlog)
end
----------------------------------------------------------------------------
JustLog("MIA:V - Loaded Common Files")