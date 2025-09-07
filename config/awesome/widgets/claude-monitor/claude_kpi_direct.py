#!/usr/bin/env python3
"""
Direct KPI extractor - gets values directly from monitor's orchestrator.
This bypasses any calculation errors by using the monitor's actual live data.
"""

import sys
import json
import signal
import time
import threading
from pathlib import Path
from datetime import datetime, timezone
from typing import Optional, Tuple

# Add monitor source to path
sys.path.insert(0, str(Path(__file__).parent / "src"))

try:
    from claude_monitor.monitoring.orchestrator import MonitoringOrchestrator
    from claude_monitor.cli.main import discover_claude_data_paths
    from claude_monitor.core.settings import Settings
except ImportError as e:
    print(f"Error importing monitor modules: {e}", file=sys.stderr)
    sys.exit(1)


class QuickKPIExtractor:
    """Extract KPIs by running monitor orchestrator briefly."""
    
    def __init__(self):
        self.cost = 0.0
        self.minutes_to_reset = 0
        self.data_received = False
        self.orchestrator = None
    
    def get_kpis(self) -> Tuple[float, int]:
        """Get KPIs by running orchestrator briefly."""
        try:
            # Find data path
            data_paths = discover_claude_data_paths()
            if not data_paths:
                return 0.0, 0
            
            # Create orchestrator
            self.orchestrator = MonitoringOrchestrator(
                update_interval=1,
                data_path=str(data_paths[0])
            )
            
            # Set up callback to capture data
            self.orchestrator.register_update_callback(self._on_data_update)
            
            # Start and wait for data
            self.orchestrator.start()
            
            # Wait for initial data with timeout
            timeout = 5.0
            start_time = time.time()
            while not self.data_received and (time.time() - start_time) < timeout:
                time.sleep(0.1)
            
            # Stop orchestrator
            self.orchestrator.stop()
            
            return self.cost, self.minutes_to_reset
            
        except Exception as e:
            print(f"Error: {e}", file=sys.stderr)
            return 0.0, 0
        finally:
            if self.orchestrator:
                self.orchestrator.stop()
    
    def _on_data_update(self, monitoring_data):
        """Callback to extract KPIs from monitoring data."""
        try:
            data = monitoring_data.get("data", {})
            blocks = data.get("blocks", [])
            
            # Find active block
            active_block = None
            for block in blocks:
                if block.get("isActive", False):
                    active_block = block
                    break
            
            if active_block:
                # Extract cost
                self.cost = round(active_block.get("costUSD", 0.0), 2)
                
                # Calculate time to reset
                end_time_str = active_block.get("endTime")
                if end_time_str:
                    end_time = datetime.fromisoformat(end_time_str.replace('Z', '+00:00'))
                    now = datetime.now(timezone.utc)
                    minutes_left = max(0, int((end_time - now).total_seconds() / 60))
                    self.minutes_to_reset = minutes_left
            
            self.data_received = True
            
        except Exception as e:
            print(f"Error processing data: {e}", file=sys.stderr)
            self.data_received = True  # Don't hang on error


def get_claude_kpis() -> Tuple[float, int]:
    """Get Claude KPIs using direct monitor access."""
    extractor = QuickKPIExtractor()
    return extractor.get_kpis()


def main():
    """Main function."""
    import argparse
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--json', action='store_true', help='Output as JSON')
    parser.add_argument('--widget', action='store_true', help='Output for widget')
    args = parser.parse_args()
    
    cost, minutes = get_claude_kpis()
    
    if args.json:
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