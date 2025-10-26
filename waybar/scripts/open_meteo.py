#!/usr/bin/env python3

import json
import time
import sys
import os
from datetime import datetime

def weather_log(place, data):
    try:
        log_path = os.path.expanduser("~/.cache/weather_cache.log")
        cache_entry = {"place": place, "data": data, "timestamp": time.time()}
        with open(log_path, "a") as f:
            f.write(f"{json.dumps(cache_entry)}\n")
    except:
        pass

def debug_log(message):
    try:
        log_path = os.path.expanduser("~/.cache/waybar_weather.log")
        with open(log_path, "a") as f:
            timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
            f.write(f"[{timestamp}] {message}\n")
    except:
        pass

def get_cache(place):
    try:
        log_path = os.path.expanduser("~/.cache/weather_cache.log")
        if os.path.exists(log_path):
            with open(log_path, "r") as f:
                dat = f.readlines()
                if dat:
                    for dater in reversed(dat):
                        try:
                            cache_entry = json.loads(dater.strip())
                            if cache_entry.get("place") == place:
                                return cache_entry
                        except:
                            continue
    except Exception as e:
        debug_log(f"Cache read error: {str(e)}")
    return None

def create_openmeteo_tooltip(weather_data, place_name):
    """Create clean tooltip from JSON data"""
    current = weather_data["current"]
    hourly = weather_data["hourly"]

    # Build tooltip
    tooltip = f"<b>{place_name}</b>\n"
    tooltip += f"Temp: <b>{int(round(current['temperature_2m']))}°C</b>\n"
    tooltip += f"Feels like: {int(round(current['apparent_temperature']))}°C\n"
    tooltip += f"Wind: {int(round(current['wind_speed_10m']))} km/h\n"
    tooltip += f"Humidity: {int(current['relative_humidity_2m'])}%\n"

    # Current precipitation
    current_precip = int(hourly["precipitation_probability"][0])
    tooltip += f"Precipitation: {current_precip}%\n"

    # Next 3 hours (starting from next hour)
    tooltip += f"\n<b>Next 3h</b>\n"
    current_hour = datetime.now().hour

    for i in range(1, 4):  # Next 3 hours: +1, +2, +3
        hour_idx = current_hour + i
        
        # Check if we have data for this hour
        if hour_idx < len(hourly["temperature_2m"]):
            display_hour = (current_hour + i) % 24
            hour_time = str(display_hour).zfill(2)
            hour_temp = int(round(hourly["temperature_2m"][hour_idx]))
            hour_code = int(hourly["weather_code"][hour_idx])
            hour_icon = icons_day.get(str(hour_code), "")
            hour_rain = int(hourly["precipitation_probability"][hour_idx])

            rain_text = f" {hour_rain}%" if hour_rain > 0 else ""
            tooltip += f"{hour_time}: {hour_icon} {hour_temp}°{rain_text}\n"

    return tooltip

def openmeteo_get_weather_data(coords):
    try:
        import requests
        
        url = "https://api.open-meteo.com/v1/forecast"
        params = {
            "latitude": coords[0],
            "longitude": coords[1],
            "daily": "weather_code",
            "hourly": "temperature_2m,weather_code,precipitation_probability",
            "current": "temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,is_day",
            "timezone": "Asia/Kolkata",
            "forecast_days": 1,
        }

        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        weather_data = response.json()
        
        debug_log("API success (direct HTTP)")
        return weather_data
        
    except Exception as e:
        debug_log(f"API error: {str(e)}")
        return None

debug_log("Script started")

icons_day = {
    "0": "", "1": "", "2": "", "3": "", "45": "", "48": "",
    "51": "", "53": "", "55": "", "61": "", "63": "", "65": "",
    "71": "", "73": "", "75": "", "80": "", "81": "", "82": "",
    "85": "", "86": "", "95": "󰙾", "96": "󰙾", "99": "󰙾",
}

icons_night = {
    "0": "", "1": "", "2": "", "3": "", "45": "", "48": "",
    "51": "", "53": "", "55": "", "61": "", "63": "", "65": "",
    "71": "", "73": "", "75": "", "80": "", "81": "", "82": "",
    "85": "", "86": "", "95": "󰙾", "96": "󰙾", "99": "󰙾",
}

try:
    import requests
except ImportError:
    print(json.dumps({"text": " Deps missing", "tooltip": "Install requests"}))
    sys.exit(0)

if __name__ == "__main__":
    try:
        coordinates = [8.546361, 76.902806]
        if coordinates[0] == 8.546361 and coordinates[1] == 76.902806:
            place = "Sreekariyam"
        elif coordinates[0] == 9.471499 and coordinates[1] == 76.553333:
            place = "Changanacherry"

        weather_data = openmeteo_get_weather_data(coordinates)
        
        if weather_data and 'current' in weather_data:
            temp = int(round(weather_data['current']['temperature_2m']))
            code = str(int(weather_data['current']['weather_code']))
            is_day = weather_data['current']['is_day']
            icon = icons_day.get(code, "") if is_day else icons_night.get(code, "")
    
            data = {
                "text": f"{place}: {icon} {temp}°",
                "tooltip": create_openmeteo_tooltip(weather_data, place)
            }
            
            debug_log(f"Success: {data['text']}")
            weather_log(place, data)
        else:
            cached_data = get_cache(place)
            if cached_data:
                data = cached_data["data"]
                time_ret = cached_data["timestamp"]
                timest = datetime.fromtimestamp(time_ret)
                human_readable = timest.strftime("%Y-%m-%d %H:%M:%S")
                debug_log(f"Using cached data from {human_readable} for {place}")
            else:
                data = {"text": "🌡️ --°", "tooltip": "Weather unavailable"}
                debug_log("Cache unavailable.")

        print(json.dumps(data))

    except Exception as e:
        debug_log(f"Main error: {str(e)}")
        print(json.dumps({"text": " Error", "tooltip": "Check ~/.cache/waybar_weather.log"}))

    sys.stdout.flush()
