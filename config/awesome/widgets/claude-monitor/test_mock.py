#!/usr/bin/env python3
import sys
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--json', action='store_true', help='Output as JSON')
    parser.add_argument('--widget', action='store_true', help='Output for widget')
    args = parser.parse_args()
    
    # Mock data for testing
    cost = 4.23
    minutes = 150  # 2h 30m
    
    if args.json:
        import json
        print(json.dumps({'cost_usd': cost, 'minutes_to_reset': minutes}))
    elif args.widget:
        hours = minutes // 60
        mins = minutes % 60
        time_str = f"{hours}h {mins}m" if hours > 0 else f"{mins}m"
        print(f"${cost:.2f} | Reset: {time_str}")
    else:
        print(f"Cost: ${cost:.2f}")
        print(f"Time to reset: {minutes} minutes")

if __name__ == "__main__":
    main()