# Read Microsoft OS descriptors to keep KP70C firmware in XINPUT mode.
import ctypes
import os
from pathlib import Path
import sys


class Control(ctypes.Structure):
    _fields_ = [
        ("request_type", ctypes.c_uint8),
        ("request", ctypes.c_uint8),
        ("value", ctypes.c_uint16),
        ("index", ctypes.c_uint16),
        ("length", ctypes.c_uint16),
        ("timeout", ctypes.c_uint32),
        ("data", ctypes.c_void_p),
    ]


libc = ctypes.CDLL(None, use_errno=True)
libc.ioctl.restype = ctypes.c_int
request_number = (3 << 30) | (ctypes.sizeof(Control) << 16) | (ord("U") << 8)


def control_read(fd, typ, req, value, index, length):
    buf = ctypes.create_string_buffer(length)
    transfer = Control(typ, req, value, index, length, 500, ctypes.addressof(buf))
    result = libc.ioctl(fd, ctypes.c_ulong(request_number), ctypes.byref(transfer))
    if result < 0:
        err = ctypes.get_errno()
        raise OSError(err, os.strerror(err))
    return buf.raw[:result]


# udev supplies the USB device node; validate identity again before any transfer.
if len(sys.argv) != 2:
    raise SystemExit("Usage: kp70-xinput-init /dev/bus/usb/BBB/DDD")
node = Path(sys.argv[1])
if (
    node.parent.parent != Path("/dev/bus/usb")
    or not node.name.isdigit()
    or not node.parent.name.isdigit()
):
    raise SystemExit("Invalid USB device path")
match = None
for device in Path("/sys/bus/usb/devices").glob("*"):
    try:
        if (
            device.joinpath("idVendor").read_text().strip() == "20bc"
            and device.joinpath("idProduct").read_text().strip() == "5173"
            and "XINPUT WIRED" in device.joinpath("product").read_text()
            and int(device.joinpath("busnum").read_text()) == int(node.parent.name)
            and int(device.joinpath("devnum").read_text()) == int(node.name)
        ):
            match = device
            break
    except (OSError, ValueError):
        continue
if match is None:
    raise SystemExit("Not a KP70C XINPUT device")
fd = os.open(node, os.O_RDWR)
try:
    vendor_code = 0xEE
    try:
        descriptor = control_read(fd, 0x80, 6, 0x03EE, 0, 18)
        if len(descriptor) >= 18 and descriptor[2:16] == "MSFT100".encode("utf-16le"):
            vendor_code = descriptor[16]
    except OSError:
        pass
    compat = control_read(fd, 0xC0, vendor_code, 0, 4, 40)
    if b"XUSB10" not in compat:
        raise SystemExit("KP70C did not return an XUSB10 compatibility descriptor")
    print("KP70C: XINPUT compatibility handshake complete")
finally:
    os.close(fd)
