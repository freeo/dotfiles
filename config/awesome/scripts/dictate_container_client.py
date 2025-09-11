#!/usr/bin/env python3
"""
Simplified dictation client for moshi-stt container.
No server management - just connects to the running container.
"""

import asyncio
import signal
import sys
import os
import argparse
import msgpack
import numpy as np
import sounddevice as sd
import subprocess
from typing import Optional

try:
    import websockets
except ImportError:
    print("❌ websockets library required: pip install websockets")
    sys.exit(1)


class TextOutput:
    """Simple text output using various tools."""
    
    def __init__(self, output_type="auto"):
        self.output_type = output_type
        self.tool = self._detect_tool(output_type)
        print(f"🔧 Text output tool: {self.tool}")
        
        # Setup if needed (for dotool)
        if self.tool in ["DOTOOL", "DOTOOLC"]:
            self._setup_dotool()
    
    def _detect_tool(self, output_type):
        """Detect the best available text output tool."""
        if output_type == "console":
            return "STDOUT"
        
        if output_type != "auto":
            return output_type.upper()
        
        # Auto-detect best tool
        tools_to_try = ["xdotool", "dotool", "wtype", "ydotool"]
        
        for tool in tools_to_try:
            if subprocess.run(["which", tool], capture_output=True).returncode == 0:
                return tool.upper()
        
        print("⚠️  No text output tools found - using stdout")
        return "STDOUT"
    
    def _setup_dotool(self):
        """Setup dotool process."""
        global _dotool_proc
        try:
            cmd = "dotoolc" if self.tool == "DOTOOLC" else "dotool"
            _dotool_proc = subprocess.Popen(cmd, stdin=subprocess.PIPE, universal_newlines=True)
            _dotool_proc.stdin.write("keydelay 4\nkeyhold 0\ntypedelay 12\ntypehold 0\n")
            _dotool_proc.stdin.flush()
        except Exception as e:
            print(f"⚠️  Failed to setup {self.tool}: {e}")
            self.tool = "STDOUT"
    
    def insert_text(self, text):
        """Insert text at cursor position."""
        if self.tool == "XDOTOOL":
            subprocess.run(["xdotool", "type", text])
        elif self.tool in ["DOTOOL", "DOTOOLC"] and '_dotool_proc' in globals():
            _dotool_proc.stdin.write(f"type {text}\n")
            _dotool_proc.stdin.flush()
        elif self.tool == "WTYPE":
            subprocess.run(["wtype", "-s", "25", text])
        elif self.tool == "YDOTOOL":
            subprocess.run(["ydotool", "type", "--type-delay", "25", text])
        else:
            print(f"{text}", end="", flush=True)
    
    def __del__(self):
        """Cleanup on destruction."""
        if self.tool in ["DOTOOL", "DOTOOLC"] and '_dotool_proc' in globals():
            try:
                _dotool_proc.terminate()
            except:
                pass


# Global for dotool process
_dotool_proc = None


class ContainerDictationClient:
    """Simple dictation client for moshi-stt container."""
    
    def __init__(self, url="ws://localhost:5455/api/asr-streaming", api_key="public_token", 
                 device=None, output_type="auto"):
        self.url = url
        self.api_key = api_key
        self.device = device
        self.output_type = output_type
        self.running = False
        self.websocket = None
        
        # Audio settings matching moshi-server expectations
        self.sample_rate = 24000
        self.blocksize = 1920  # 80ms blocks
        self.channels = 1
        self.dtype = "float32"
        
        # Text output handler
        self.text_output = None
        
        # Initialize text output for cursor insertion
        try:
            self.text_output = TextOutput(output_type)
            print(f"✅ Cursor insertion enabled ({self.text_output.tool})")
        except Exception as e:
            print(f"⚠️  Cursor insertion failed: {e}")
            print("   Will show output in console only")
            self.text_output = TextOutput("console")

    async def start_dictation(self):
        """Start dictation - connects to container and streams audio."""
        print(f"🔗 Connecting to {self.url}", flush=True)
        
        headers = {"kyutai-api-key": self.api_key}
        audio_queue = asyncio.Queue()
        
        try:
            async with websockets.connect(self.url, additional_headers=headers) as websocket:
                self.websocket = websocket
                print("✅ Connected to container server", flush=True)
                
                # Start audio capture
                loop = asyncio.get_event_loop()
                
                def audio_callback(indata, frames, time, status):
                    if status:
                        print(f"🎤 Audio status: {status}")
                    
                    # Convert to float32 mono
                    audio_data = indata[:, 0].astype(np.float32).copy()
                    loop.call_soon_threadsafe(audio_queue.put_nowait, audio_data)
                
                # Set device if specified
                if self.device is not None:
                    sd.default.device[0] = self.device
                    print(f"🎤 Using audio device: {self.device}")
                else:
                    print("🎤 Using system default audio device")
                
                # Start audio stream
                with sd.InputStream(
                    samplerate=self.sample_rate,
                    channels=self.channels,
                    dtype=self.dtype,
                    callback=audio_callback,
                    blocksize=self.blocksize,
                ):
                    print("🎤 Audio stream started")
                    print("🗣️  Speak now - text will appear in console AND at cursor:")
                    print("-" * 60)
                    
                    # Create tasks for sending and receiving
                    send_task = asyncio.create_task(self._send_audio_loop(audio_queue))
                    receive_task = asyncio.create_task(self._receive_messages_loop())
                    
                    self.running = True
                    
                    # Wait for tasks to complete
                    try:
                        await asyncio.gather(send_task, receive_task)
                    except asyncio.CancelledError:
                        print("🔄 Tasks cancelled during shutdown")
                        send_task.cancel()
                        receive_task.cancel()
                        await asyncio.gather(send_task, receive_task, return_exceptions=True)
                        
        except websockets.ConnectionClosed:
            print("🔌 Connection closed")
        except Exception as e:
            print(f"❌ Connection error: {e}")
            raise

    async def _send_audio_loop(self, audio_queue):
        """Send audio data to server."""
        try:
            # Start by draining the queue to avoid lags
            while not audio_queue.empty():
                await audio_queue.get()

            print("📤 Starting audio transmission...")

            while self.running:
                try:
                    audio_data = await asyncio.wait_for(audio_queue.get(), timeout=0.1)
                    chunk = {"type": "Audio", "pcm": [float(x) for x in audio_data]}
                    msg = msgpack.packb(chunk, use_bin_type=True, use_single_float=True)
                    await self.websocket.send(msg)
                except asyncio.TimeoutError:
                    continue  # Check running status again

        except websockets.ConnectionClosed:
            print("⚠️  Connection closed while sending messages.")

    async def _receive_messages_loop(self):
        """Receive messages and handle both console output and cursor insertion."""
        try:
            async for message in self.websocket:
                if not self.running:
                    break
                data = msgpack.unpackb(message, raw=False)
                
                if data["type"] == "Ready":
                    print("🟢 Server ready - start speaking!", flush=True)
                
                elif data["type"] == "Word":
                    # Word transcription result
                    word = data.get("text", "")
                    
                    if word.strip():
                        # Insert at cursor immediately
                        if self.text_output:
                            self.text_output.insert_text(word + " ")
                
                elif data["type"] == "Step":
                    # VAD/stepping information for pause detection
                    pause_predictions = data.get("prs", [])
                    
                    if len(pause_predictions) > 2:
                        pause_prediction = pause_predictions[2]  # 2.0 second predictor
                        
                        if pause_prediction > 0.5:
                            # Visual pause indicator
                            if self.text_output.tool == "STDOUT":
                                print(" | ", end="", flush=True)

                elif data["type"] == "EndWord":
                    # EndWord messages - just timing info
                    stop_time = data.get("stop_time", 0)
                    # Could use this for debugging if needed
                    pass
                
        except websockets.ConnectionClosed as e:
            print(f"\n⚠️  WebSocket connection closed: {e}")
        except Exception as e:
            print(f"\n❌ Error in message loop: {e}")

    def stop(self):
        """Stop dictation."""
        if not self.running:
            return
            
        self.running = False
        print("\n🛑 Dictation stopped")
        
        # Close WebSocket if open
        if self.websocket:
            try:
                asyncio.create_task(self.websocket.close())
            except:
                pass


def main():
    parser = argparse.ArgumentParser(description="Container Dictation Client - connects to moshi-stt container")
    parser.add_argument(
        "--url",
        default="ws://localhost:5455/api/asr-streaming",
        help="WebSocket URL of container server"
    )
    parser.add_argument(
        "--api-key", 
        default="public_token",
        help="API key for authentication"
    )
    parser.add_argument(
        "--device", 
        type=int,
        help="Audio input device ID"
    )
    parser.add_argument(
        "--output",
        default="auto",
        choices=["auto", "xdotool", "ydotool", "dotool", "wtype", "console"],
        help="Text output method for cursor insertion"
    )
    parser.add_argument(
        "--list-devices",
        action="store_true",
        help="List available audio devices and exit"
    )
    
    args = parser.parse_args()
    
    if args.list_devices:
        print("Available audio input devices:")
        devices = sd.query_devices()
        for i, device in enumerate(devices):
            if device["max_input_channels"] > 0:
                print(f"  {i:2d}: {device['name']} ({device['max_input_channels']} channels, {device['default_samplerate']} Hz)")
        return
    
    # Create dictation instance
    client = ContainerDictationClient(
        url=args.url,
        api_key=args.api_key,
        device=args.device,
        output_type=args.output
    )
    
    # Handle Ctrl+C gracefully
    def signal_handler(signum, frame):
        print(f"\n🛑 Received signal {signum}")
        client.stop()
    
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    try:
        print("🎯 Container Dictation Client")
        print("=" * 70)
        print(f"Server: {args.url}")
        print(f"Device: {args.device if args.device else 'system default'}")
        print(f"Output: {args.output}")
        print("\nPress Ctrl+C to stop")
        print("=" * 70)
        
        # Run dictation
        asyncio.run(client.start_dictation())
        
    except KeyboardInterrupt:
        print("\n🛑 Keyboard interrupt received")
        client.stop()
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()