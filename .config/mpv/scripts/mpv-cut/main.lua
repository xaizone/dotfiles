mp.msg.info("MPV-CUT LOADED")

utils = require "mp.utils"

local function print(s)
	mp.msg.info(s)
	mp.osd_message(s)
end

local function table_to_str(o)
	if type(o) == 'table' then
		local s = ''
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. table_to_str(v) .. '\n'
		end
		return s
	else
		return tostring(o)
	end
end

local function to_hms(seconds)
	local ms = math.floor((seconds - math.floor(seconds)) * 1000)
	local secs = math.floor(seconds)
	local mins = math.floor(secs / 60)
	secs = secs % 60
	local hours = math.floor(mins / 60)
	mins = mins % 60
	return string.format("%02d-%02d-%02d-%03d", hours, mins, secs, ms)
end

local function next_table_key(t, current)
	local keys = {}
	for k in pairs(t) do
		keys[#keys + 1] = k
	end
	table.sort(keys)
	for i = 1, #keys do
		if keys[i] == current then
			return keys[(i % #keys) + 1]
		end
	end
	return keys[1]
end

ACTIONS = {}

ACTIONS.COPY = function(d)
	local args = {
		"ffmpeg",
		"-nostdin", "-y",
		"-loglevel", "error",
		"-ss", d.start_time,
		"-t", d.duration,
		"-i", d.inpath,
		"-c", "copy",
		"-map", "0",
		"-dn",
		"-avoid_negative_ts", "make_zero",
		utils.join_path(d.indir, "CUT_" .. d.infile_noext .. "_FROM_" .. d.start_time_hms .. "_TO_" .. d.end_time_hms .. d.ext)
	}
	mp.command_native_async({
		name = "subprocess",
		args = args,
		playback_only = false,
	}, function() print("Done") end)
end

ACTIONS.ENCODE = function(d)
	local args = {
		"ffmpeg",
		"-nostdin", "-y",
		"-loglevel", "error",
		"-ss", d.start_time,
		"-t", d.duration,
		"-i", d.inpath,
		"-pix_fmt", "yuv420p",
		"-crf", "20",
		"-preset", "superfast",
		utils.join_path(d.indir, "ENCODE_" .. d.infile_noext .. "_FROM_" .. d.start_time_hms .. "_TO_" .. d.end_time_hms .. d.ext)
	}
	mp.command_native_async({
		name = "subprocess",
		args = args,
		playback_only = false,
	}, function() print("Done") end)
end

ACTION = "COPY"

CHANNEL = 1

CHANNEL_NAMES = {}

KEY_CUT = "c"
KEY_CANCEL_CUT = "C"
KEY_CYCLE_ACTION = "a"

for i, v in ipairs(CHANNEL_NAMES) do
    CHANNEL_NAMES[i] = string.gsub(v, ":", "-")
end

if not ACTIONS[ACTION] then ACTION = next_table_key(ACTIONS, nil) end

START_TIME = nil

local function get_current_channel_name()
	return CHANNEL_NAMES[CHANNEL] or tostring(CHANNEL)
end

local function get_data()
	local d = {}
	d.inpath = mp.get_property("path")
	d.indir = utils.split_path(d.inpath)
	d.infile = mp.get_property("filename")
	d.infile_noext = mp.get_property("filename/no-ext")
	d.ext = mp.get_property("filename"):match("^.+(%..+)$") or ".mp4"
	d.channel = get_current_channel_name()
	return d
end

local function get_times(start_time, end_time)
	local d = {}
	d.start_time = tostring(start_time)
	d.end_time = tostring(end_time)
	d.duration = tostring(end_time - start_time)
	d.start_time_hms = tostring(to_hms(start_time))
	d.end_time_hms = tostring(to_hms(end_time))
	d.duration_hms = tostring(to_hms(end_time - start_time))
	return d
end

text_overlay = mp.create_osd_overlay("ass-events")
text_overlay.hidden = true
text_overlay:update()

local function text_overlay_off()
	-- https://github.com/mpv-player/mpv/issues/10227
	text_overlay:update()
	text_overlay.hidden = true
	text_overlay:update()
end

local function text_overlay_on()
	local channel = get_current_channel_name()
	text_overlay.data = string.format("%s in %s from %s", ACTION, channel, START_TIME)
	text_overlay.hidden = false
	text_overlay:update()
end

local function print_or_update_text_overlay(content)
	if START_TIME then text_overlay_on() else print(content) end
end

local function cycle_action()
	ACTION = next_table_key(ACTIONS, ACTION)
	print_or_update_text_overlay("ACTION: " .. ACTION)
end

local function cut(start_time, end_time)
	local d = get_data()
	local t = get_times(start_time, end_time)
	for k, v in pairs(t) do d[k] = v end
	mp.msg.info(ACTION)
	mp.msg.info(table_to_str(d))
	ACTIONS[ACTION](d)
end

local function put_time()
	local time = mp.get_property_number("time-pos")
	if not START_TIME then
		START_TIME = time
		text_overlay_on()
		return
	end
	text_overlay_off()
	if time > START_TIME then
		cut(START_TIME, time)
		START_TIME = nil
	else
		print("INVALID")
		START_TIME = nil
	end
end

local function cancel_cut()
	text_overlay_off()
	START_TIME = nil
	print("CANCELLED CUT")
end

mp.add_key_binding(KEY_CUT, "cut", put_time)
mp.add_key_binding(KEY_CANCEL_CUT, "cancel_cut", cancel_cut)
mp.add_key_binding(KEY_CYCLE_ACTION, "cycle_action", cycle_action)
