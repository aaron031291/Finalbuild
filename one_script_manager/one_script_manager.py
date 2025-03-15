#!/usr/bin/env python3
import argparse

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Script Manager Automation")
    parser.add_argument("--src", required=True, help="Source directory for script updates")
    parser.add_argument("--dest", required=True, help="Destination directory for structured scripts")
    parser.add_argument("--one", required=True, help="Output file for the unified script")

    args = parser.parse_args()

    ensure_directory(args.src)
    ensure_directory(args.dest)

    deduplicate_and_merge(args.src, args.dest)
    generate_one_script(args.dest, args.one)

    start_watchdog(args.src, args.dest, args.one)

