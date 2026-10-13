"""Switch a Logitech host once per attempt and verify the source connection."""

import argparse
import json
import time


def switch_host(device, feature, target, attempts=3, delay=time.sleep):
    """Retry only while the device still reports its original host."""
    info = device.feature_request(feature, 0x00)
    if not info or len(info) < 2:
        raise RuntimeError("Cannot read the current Easy-Switch host")
    count, source = info[:2]
    if not 0 <= target < count:
        raise RuntimeError("Target host is outside this device's host range")
    if source == target:
        return "already-selected"
    for attempt in range(1, attempts + 1):
        print(
            f"Host {source + 1} -> {target + 1}, attempt {attempt}/{attempts}",
            flush=True,
        )
        device.feature_request(feature, 0x10, bytes([target]), no_reply=True)
        missing = 0
        for _ in range(4):
            delay(0.4)
            if not device.ping():
                missing += 1
                if missing == 2:
                    return "left-source-host"
                continue
            missing = 0
            info = device.feature_request(feature, 0x00)
            if not info or len(info) < 2:
                raise RuntimeError("Device is online but its host cannot be verified")
            if info[1] == target:
                return "target-selected"
            if info[1] != source:
                raise RuntimeError("Host changed unexpectedly; refusing to retry")
        if missing:
            raise RuntimeError("Source connection is uncertain; refusing a blind retry")
    raise RuntimeError(
        "Device remained connected to the original host after all attempts"
    )


def main():
    """Discover exactly one online device and issue a nonpersistent host change."""
    from logitech_receiver import base, device as devices, receiver
    from logitech_receiver.hidpp20_constants import SupportedFeature

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--device", default="MX Master 4")
    parser.add_argument("--host", type=int, choices=(1, 2, 3), default=2)
    parser.add_argument("--status", action="store_true")
    args = parser.parse_args()
    handles = []
    found = []
    try:
        for info in base.receivers_and_devices():
            item = (
                devices.create_device(base, info)
                if info.isDevice
                else receiver.create_receiver(base, info)
            )
            if item is None:
                continue
            handles.append(item)
            if not item.isDevice and not item.count():
                continue
            for candidate in [item] if item.isDevice else item:
                names = [
                    candidate.name,
                    candidate.codename,
                    candidate.serial,
                    candidate.unitId,
                ]
                if (
                    any(
                        args.device.lower() in str(name).lower()
                        for name in names
                        if name
                    )
                    and candidate.ping()
                ):
                    found.append(candidate)
        if len(found) != 1:
            raise RuntimeError(
                f"Expected one online device matching {args.device!r}, found {len(found)}"
            )
        selected = found[0]
        feature = SupportedFeature.CHANGE_HOST
        if args.status:
            info = selected.feature_request(feature, 0x00)
            if not info or len(info) < 2:
                raise RuntimeError("Cannot read Easy-Switch hosts")
            print(
                json.dumps(
                    {
                        "device": selected.name,
                        "serial": selected.serial,
                        "host_count": info[0],
                        "current_host": info[1] + 1,
                    }
                )
            )
        else:
            result = switch_host(selected, feature, args.host - 1)
            print(
                json.dumps(
                    {
                        "device": selected.name,
                        "target_host": args.host,
                        "result": result,
                    }
                )
            )
    finally:
        for handle in handles:
            handle.close()


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        raise SystemExit(f"Mouse switch failed: {error}") from error
