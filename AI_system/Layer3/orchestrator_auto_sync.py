#!/usr/bin/env python3
"""
Layer 3 Orchestrator Auto-Sync System
Automatically detects, connects, and syncs all AI layers dynamically.
"""

import os
import time
import subprocess
import logging
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from typing import Dict

# Configuration
BASE_DIR = os.path.abspath(os.path.join(os.getcwd(), "AI_system"))
LOG_FILE = "/var/log/orchestrator.log"
LAYERS = ["Layer1", "Layer2", "Layer3", "Layer4", "Layer5", "Layer6"]
CHECK_INTERVAL = 10  # Check every 10 seconds

# Setup logging
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

class LayerMonitor(FileSystemEventHandler):
    """Monitors AI layers for changes and triggers auto-sync"""

    def __init__(self, orchestrator):
        self.orchestrator = orchestrator

    def on_modified(self, event):
        """Triggers when a layer file is updated"""
        if event.src_path.startswith(BASE_DIR):
            logging.info(f"Change detected in {event.src_path}. Resyncing system...")
            self.orchestrator.sync_layers()

class Orchestrator:
    """Manages and syncs all AI layers dynamically"""

    def __init__(self):
        self.layers_status: Dict[str, bool] = {layer: False for layer in LAYERS}
        self._observer = Observer()

    def detect_layers(self):
        """Detects all available AI layers"""
        for layer in LAYERS:
            layer_path = os.path.join(BASE_DIR, layer)
            if os.path.isdir(layer_path):
                self.layers_status[layer] = True
            else:
                logging.warning(f"Missing layer: {layer}")

    def check_layer_status(self):
        """Checks if all layers are running"""
        for layer in LAYERS:
            if not self.layers_status[layer]:
                logging.error(f"{layer} is not active. Restarting...")
                self.restart_layer(layer)

    def restart_layer(self, layer):
        """Restarts a failed layer"""
        layer_path = os.path.join(BASE_DIR, layer)
        if os.path.isdir(layer_path):
            start_script = os.path.join(layer_path, "start.sh")
            if os.path.exists(start_script):
                subprocess.Popen(["bash", start_script], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                logging.info(f"Restarted {layer} successfully.")
            else:
                logging.error(f"Missing start script for {layer}. Manual intervention required.")

    def sync_layers(self):
        """Synchronizes all layers and ensures smooth operation"""
        logging.info("Syncing all layers...")
        self.detect_layers()
        self.check_layer_status()
        logging.info("Layer sync complete.")

    def start_monitoring(self):
        """Monitors AI layers for changes and auto-syncs them"""
        event_handler = LayerMonitor(self)
        self._observer.schedule(event_handler, BASE_DIR, recursive=True)
        self._observer.start()
        logging.info("Monitoring AI layers for real-time updates.")

    def stop_monitoring(self):
        """Stops monitoring AI layers"""
        self._observer.stop()
        self._observer.join()

    def run(self):
        """Main orchestrator loop"""
        logging.info("Starting Orchestrator Auto-Sync System...")
        self.sync_layers()
        self.start_monitoring()

        try:
            while True:
                time.sleep(CHECK_INTERVAL)
        except KeyboardInterrupt:
            self.stop_monitoring()
            logging.info("Orchestrator shutting down.")

if __name__ == "__main__":
    orchestrator = Orchestrator()
    orchestrator.run()
