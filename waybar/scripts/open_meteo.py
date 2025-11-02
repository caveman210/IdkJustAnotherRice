#!/usr/bin/env python3

import json
import time
import sys
import os
from datetime import datetime

# 'requests' is imported in the functions, but good to have here.
import requests

# --- Logging and Caching ---


def weather_log(place, data):
    """Logs successful weather data to the cache file."""
    try:
        log_path = os.path.expanduser("~/.cache/weather_cache.log")
        cache_entry = {"place": place, "data": data, "timestamp": time.time()}
        with open(log_path, "a") as f:
            f.write(f"{json.dumps(cache_entry)}\n")
    except Exception as e:
        debug_log(f"Cache write error: {str(e)}")  # Log the error!


def debug_log(message):
    """Logs a debug message."""
    try:
        log_path = os.path.expanduser("~/.cache/waybar_weather.log")
        with open(log_path, "a") as f:
            timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
            f.write(f"[{timestamp}] {message}\n")
    except Exception as e:
        # If debug_log fails, print to stderr as a last resort
        print(
            f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] DEBUG_LOG_FAILED: {e}\n{
                message
            }\n",
            file=sys.stderr,
        )


def get_cache(place):
    """Gets the latest cache entry for a specific place."""
    try:
        log_path = os.path.expanduser("~/.cache/weather_cache.log")
        if os.path.exists(log_path):
            with open(log_path, "r") as f:
                dat = f.readlines()
                if dat:
                    # Search from latest to oldest
                    for dater in reversed(dat):
                        try:
                            cache_entry = json.loads(dater.strip())
                            if cache_entry.get("place") == place:
                                return cache_entry
                        except json.JSONDecodeError:
                            # Corrupt line in cache, just skip it
                            continue
    except Exception as e:
        debug_log(f"Cache read error: {str(e)}")
    return None


# --- Data and Tooltip ---


def create_openmeteo_tooltip(weather_data, place_name):
    """Create clean tooltip from JSON data"""
    try:
        current = weather_data["current"]
        hourly = weather_data["hourly"]

        # Build tooltip
        tooltip = f"<b>{place_name}</b>\n"
        tooltip += f"Temp: <b>{int(round(current['temperature_2m']))}°C</b>\n"
        tooltip += f"Feels like: {int(round(current['apparent_temperature']))}°C\n"
        tooltip += f"Wind: {int(round(current['wind_speed_10m']))} km/h\n"
        tooltip += f"Humidity: {int(current['relative_humidity_2m'])}%\n"

        # Current precipitation
        if hourly.get("precipitation_probability"):
            current_precip = int(hourly["precipitation_probability"][0])
            tooltip += f"Precipitation: {current_precip}%\n"

        # Next 3 hours
        tooltip += f"\n<b>Next 3h</b>\n"
        current_hour = datetime.now().hour

        for i in range(1, 4):  # Next 3 hours: +1, +2, +3
            hour_idx = current_hour + i

            if hour_idx < len(hourly["temperature_2m"]):
                display_hour = (current_hour + i) % 24
                hour_time = str(display_hour).zfill(2)
                hour_temp = int(round(hourly["temperature_2m"][hour_idx]))
                hour_code = int(hourly["weather_code"][hour_idx])
                hour_icon = icons_day.get(str(hour_code), "")
                hour_rain = int(hourly["precipitation_probability"][hour_idx])

                rain_text = f" {hour_rain}%" if hour_rain > 0 else ""
                tooltip += f"{hour_time}: {hour_icon} {hour_temp}°{rain_text}\n"

        return tooltip.strip()
    except Exception as e:
        debug_log(f"Tooltip creation error: {e}")
        return "Error creating tooltip"


# --- API Functions ---
def coord_finder():
    """
    Tries a list of location APIs in order.
    Returns [city, lat, lon] from the first one that succeeds.
    """
    # Define the order of APIs to try.
    # We put ipinfo first since ip-api is blocking you.
    locator_functions = [
        get_loc_ipinfo,
        get_loc_freeipapi,
        get_loc_ipapi,  # Keep this last as a final fallback
    ]

    coordinates = None
    for func in locator_functions:
        try:
            coordinates = func()
            if coordinates:
                # Success! Stop and return the data.
                debug_log(f"Location success via {func.__name__}")
                return coordinates
        except Exception as e:
            # This catches any unexpected error in the helper function itself
            debug_log(f"Error in {func.__name__}: {e}")

    # If the loop finishes, all APIs failed.
    debug_log("All location APIs failed.")
    return None


def get_loc_ipinfo():
    """Tries to get location from ipinfo.io"""
    try:
        import requests

        url = "https://ipinfo.io/json"
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()

        lat, lon = data["loc"].split(",")
        return [data["city"], float(lat), float(lon)]

    except Exception as e:
        debug_log(f"ipinfo.io failed: {e}")
        return None


def get_loc_freeipapi():
    """Tries to get location from freeipapi.com"""
    try:
        import requests

        url = "https://freeipapi.com/api/json/"
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()

        return [data["cityName"], data["latitude"], data["longitude"]]

    except Exception as e:
        debug_log(f"freeipapi.com failed: {e}")
        return None


def get_loc_ipapi():
    """Tries to get location from ip-api.com (your original)"""
    try:
        import requests

        url = "https://ip-api.com/json"
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()

        return [data["city"], data["lat"], data["lon"]]

    except Exception as e:
        debug_log(f"ip-api.com failed: {e}")
        return None


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

        debug_log("API success (openmeteo)")
        return weather_data

    except Exception as e:
        debug_log(f"API error (openmeteo): {str(e)}")
        return None


# --- Main Execution ---

debug_log("Script started")

icons_day = {
    "0": "",
    "1": "",
    "2": "",
    "3": "",
    "45": "",
    "48": "",
    "51": "",
    "53": "",
    "55": "",
    "61": "",
    "63": "",
    "65": "",
    "71": "",
    "73": "",
    "75": "",
    "80": "",
    "81": "",
    "82": "",
    "85": "",
    "86": "",
    "95": "󰙾",
    "96": "󰙾",
    "99": "󰙾",
}
icons_night = {
    "0": "",
    "1": "",
    "2": "",
    "3": "",
    "45": "",
    "48": "",
    "51": "",
    "53": "",
    "55": "",
    "61": "",
    "63": "",
    "65": "",
    "71": "",
    "73": "",
    "75": "",
    "80": "",
    "81": "",
    "82": "",
    "85": "",
    "86": "",
    "95": "󰙾",
    "96": "󰙾",
    "99": "󰙾",
}

if __name__ == "__main__":
    # Define defaults
    data = {}
    place = "Unknown"

    try:
        coordinates = coord_finder()

        # --- CRITICAL FIX: Main Logic ---
        # This structure prevents the 'NoneType' crash

        if coordinates:
            place = coordinates[0]  # We have a valid place
            weather_data = openmeteo_get_weather_data([coordinates[1], coordinates[2]])

            if weather_data and "current" in weather_data:
                # --- API SUCCESS ---
                temp = int(round(weather_data["current"]["temperature_2m"]))
                code = str(int(weather_data["current"]["weather_code"]))
                is_day = weather_data["current"]["is_day"]
                icon = (
                    icons_day.get(code, "") if is_day else icons_night.get(code, "")
                )

                data = {
                    "text": f"{place}: {icon} {temp}°",
                    "tooltip": create_openmeteo_tooltip(weather_data, place),
                }

                debug_log(f"Success: {data['text']}")
                weather_log(place, data)  # Log to cache

        # --- FALLBACK TO CACHE ---
        # This block runs if:
        # 1. coordinates was None (coord_finder failed)
        # 2. weather_data was None (openmeteo failed)
        if not data:
            debug_log(f"API failed. Trying cache for: {place}")
            # 'place' will be "Unknown" if coord_finder failed
            # or the correct city if openmeteo failed

            cached_data = get_cache(place)

            if cached_data:
                data = cached_data["data"]
                time_ret = cached_data["timestamp"]
                timest = datetime.fromtimestamp(time_ret)
                human_readable = timest.strftime("%Y-%m-%d %H:%M:%S")
                debug_log(f"Using cached data from {human_readable} for {place}")
            else:
                data = {"text": "🌡️ --°", "tooltip": f"Weather unavailable for {place}"}
                debug_log("Cache unavailable.")

        print(json.dumps(data))

    except Exception as e:
        # This catches any unexpected errors
        debug_log(f"Main error: {str(e)}")
        print(
            json.dumps(
                {"text": " Error", "tooltip": "Check ~/.cache/waybar_weather.log"}
            )
        )

    sys.stdout.flush()
