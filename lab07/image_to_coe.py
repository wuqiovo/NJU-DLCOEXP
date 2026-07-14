#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Convert an image to a Vivado COE file for the VGA framebuffer used in lab07.

Target format:
- Visible resolution: 640 x 480
- Memory organization: 640 x 512
- Pixel width: 12 bits, RGB444
- Address mapping: addr = (h_addr << 9) | v_addr
  Therefore pixels are stored column by column:
  (x=0,y=0..511), (x=1,y=0..511), ...

Dependencies:
    pip install pillow

Examples:
    python image_to_coe.py input.png output.coe
    python image_to_coe.py input.jpg output.coe --mode fit
    python image_to_coe.py input.jpg output.coe --mode stretch
"""

from __future__ import annotations

import argparse
from pathlib import Path
from PIL import Image, ImageOps


VISIBLE_WIDTH = 640
VISIBLE_HEIGHT = 480
MEMORY_HEIGHT = 512


def prepare_image(image: Image.Image, mode: str, background: tuple[int, int, int]) -> Image.Image:
    """Convert image to RGB and make it exactly 640x480."""
    image = image.convert("RGB")

    if mode == "stretch":
        return image.resize((VISIBLE_WIDTH, VISIBLE_HEIGHT), Image.Resampling.LANCZOS)

    if mode == "crop":
        # Fill the entire 640x480 area; excess parts are cropped.
        return ImageOps.fit(
            image,
            (VISIBLE_WIDTH, VISIBLE_HEIGHT),
            method=Image.Resampling.LANCZOS,
            centering=(0.5, 0.5),
        )

    if mode == "fit":
        # Keep the full image; unused area is filled with the background color.
        fitted = ImageOps.contain(
            image,
            (VISIBLE_WIDTH, VISIBLE_HEIGHT),
            method=Image.Resampling.LANCZOS,
        )
        canvas = Image.new("RGB", (VISIBLE_WIDTH, VISIBLE_HEIGHT), background)
        left = (VISIBLE_WIDTH - fitted.width) // 2
        top = (VISIBLE_HEIGHT - fitted.height) // 2
        canvas.paste(fitted, (left, top))
        return canvas

    raise ValueError(f"Unsupported resize mode: {mode}")


def rgb888_to_rgb444(pixel: tuple[int, int, int]) -> int:
    """Convert an 8-bit-per-channel RGB pixel to 12-bit RGB444."""
    r, g, b = pixel
    r4 = r >> 4
    g4 = g >> 4
    b4 = b >> 4
    return (r4 << 8) | (g4 << 4) | b4


def parse_hex_color(value: str) -> tuple[int, int, int]:
    """Parse a color in RRGGBB or #RRGGBB format."""
    value = value.lstrip("#")
    if len(value) != 6:
        raise argparse.ArgumentTypeError("background color must be RRGGBB, e.g. 000000")
    try:
        return tuple(int(value[i:i + 2], 16) for i in (0, 2, 4))
    except ValueError as exc:
        raise argparse.ArgumentTypeError("background color contains invalid hex digits") from exc


def write_coe(image: Image.Image, output_path: Path, pad_color: int = 0x000) -> None:
    """
    Write the image in column-major order.

    Address:
        addr = (x << 9) | y
    Thus every x coordinate occupies 512 consecutive memory words.
    Rows y=480..511 are padding and are normally black.
    """
    pixels = image.load()
    total_words = VISIBLE_WIDTH * MEMORY_HEIGHT

    with output_path.open("w", encoding="ascii", newline="\n") as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")

        index = 0
        for x in range(VISIBLE_WIDTH):
            for y in range(MEMORY_HEIGHT):
                if y < VISIBLE_HEIGHT:
                    value = rgb888_to_rgb444(pixels[x, y])
                else:
                    value = pad_color

                index += 1
                ending = ";\n" if index == total_words else ",\n"
                f.write(f"{value:03X}{ending}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert an image to a 640x512, 12-bit RGB444 Vivado COE file."
    )
    parser.add_argument("input", type=Path, help="input image file")
    parser.add_argument("output", type=Path, help="output .coe file")
    parser.add_argument(
        "--mode",
        choices=("crop", "fit", "stretch"),
        default="crop",
        help=(
            "crop: fill screen and crop excess; "
            "fit: keep whole image and add borders; "
            "stretch: resize directly to 640x480"
        ),
    )
    parser.add_argument(
        "--background",
        type=parse_hex_color,
        default=(0, 0, 0),
        metavar="RRGGBB",
        help="background color used by fit mode, default: 000000",
    )
    parser.add_argument(
        "--preview",
        type=Path,
        default=None,
        help="optional path for saving the processed 640x480 preview image",
    )
    args = parser.parse_args()

    if not args.input.is_file():
        parser.error(f"input file does not exist: {args.input}")

    try:
        with Image.open(args.input) as source:
            image = prepare_image(source, args.mode, args.background)
    except Exception as exc:
        parser.error(f"failed to read or process image: {exc}")

    args.output.parent.mkdir(parents=True, exist_ok=True)
    write_coe(image, args.output)

    if args.preview is not None:
        args.preview.parent.mkdir(parents=True, exist_ok=True)
        image.save(args.preview)

    print(f"COE file generated: {args.output}")
    print(f"Visible image: {VISIBLE_WIDTH}x{VISIBLE_HEIGHT}")
    print(f"Memory depth: {VISIBLE_WIDTH * MEMORY_HEIGHT}")
    print("Pixel format: RGB444, 12 bits")
    print("Storage order: column-major, addr = (x << 9) | y")


if __name__ == "__main__":
    main()
