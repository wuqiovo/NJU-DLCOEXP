from pathlib import Path
import sys


def chunks(data: bytes, size: int):
    for pos in range(0, len(data), size):
        yield data[pos:pos + size]


def main():
    build = Path(sys.argv[1] if len(sys.argv) > 1 else "build")
    text = (build / "text.bin").read_bytes()
    data = (build / "data.bin").read_bytes()

    with (build / "main.hex").open("w", encoding="ascii") as out:
        for part in chunks(text, 4):
            word = int.from_bytes(part.ljust(4, b"\x00"), "little")
            out.write(f"{word:08x}\n")

    lane_files = [
        (build / f"main_d{lane}.hex").open("w", encoding="ascii")
        for lane in range(4)
    ]

    try:
        for part in chunks(data, 4):
            word = part.ljust(4, b"\x00")
            for lane in range(4):
                lane_files[lane].write(f"{word[lane]:02x}\n")
    finally:
        for file in lane_files:
            file.close()


if __name__ == "__main__":
    main()