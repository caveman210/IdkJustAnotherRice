#!/usr/bin/env python3

import sys
import time
import os
import requests  # Good to import at the top
from datetime import datetime


def debug_log(message):
    """Logs a debug message."""
    try:
        # Changed log file to be specific to this script
        log_path = os.path.expanduser("~/.cache/sherlock_location.log")
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


def coord_finder():
    """
    Tries a list of location APIs in order.
    Returns [city, lat, lon] from the first one that succeeds.
    """
    locator_functions = [
        get_loc_ipinfo,
        get_loc_freeipapi,
        get_loc_ipapi,
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

    debug_log("All location APIs failed.")
    return None


def get_loc_ipinfo():
    """Tries to get location from ipinfo.io"""
    try:
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
        url = "https://freeipapi.com/api/json/"
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()

        return [data["cityName"], data["latitude"], data["longitude"]]

    except Exception as e:
        debug_log(f"freeipapi.com failed: {e}")
        return None


def get_loc_ipapi():
    """Tries to get location from ip-api.com"""
    try:
        url = "https://ip-api.com/json"
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()

        return [data["city"], data["lat"], data["lon"]]

    except Exception as e:
        debug_log(f"ip-api.com failed: {e}")
        return None


if __name__ == "__main__":
    # Start with a default in case all APIs fail
    place = "Unknown"

    try:
        coordinates = coord_finder()

        # CRITICAL FIX: Check if coord_finder returned data
        if coordinates:
            place = coordinates[0]
        else:
            # All APIs failed. The error is already logged.
            # 'place' will remain "Unknown"
            pass

    except Exception as e:
        # Catch any other major error
        debug_log(f"Main execution error: {e}")
        # 'place' will remain "Unknown"

    # CRITICAL FIX: Print the final result to stdout
    print(place)
    sys.stdout.flush()
