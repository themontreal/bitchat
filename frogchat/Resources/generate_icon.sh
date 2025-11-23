#!/bin/bash
# Generate a simple frog emoji icon for FrogChat

OUTPUT_DIR="Assets.xcassets/AppIcon.appiconset"
OUTPUT_FILE="$OUTPUT_DIR/AppIcon-1024.png"

echo "🐸 Generating FrogChat Icon..."

# Check if ImageMagick is installed
if command -v convert &> /dev/null; then
    echo "Using ImageMagick to generate icon..."

    # Create a 1024x1024 icon with frog emoji
    convert -size 1024x1024 xc:"#2d5016" \
        -gravity center \
        -pointsize 700 \
        -font "Apple-Color-Emoji" \
        -fill white \
        -annotate +0+0 "🐸" \
        "$OUTPUT_FILE"

    echo "✅ Icon generated at $OUTPUT_FILE"

elif command -v python3 &> /dev/null; then
    echo "Using Python to generate icon..."

    python3 << 'PYTHON'
from PIL import Image, ImageDraw, ImageFont
import os

# Create a 1024x1024 image with swamp green background
img = Image.new('RGB', (1024, 1024), color='#2d5016')
draw = ImageDraw.Draw(img)

# Try to load emoji font
try:
    # Try common emoji font locations
    font_paths = [
        '/System/Library/Fonts/Apple Color Emoji.ttc',
        '/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf',
        '/System/Library/Fonts/Supplemental/Apple Color Emoji.ttc'
    ]

    font = None
    for path in font_paths:
        if os.path.exists(path):
            font = ImageFont.truetype(path, 700)
            break

    if font:
        # Draw frog emoji
        text = "🐸"
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        position = ((1024 - text_width) // 2, (1024 - text_height) // 2)
        draw.text(position, text, font=font, fill='white', embedded_color=True)
    else:
        # Fallback: Draw green circle (lily pad)
        draw.ellipse([162, 162, 862, 862], fill='#7cb342', outline='white', width=20)

except Exception as e:
    print(f"Could not use emoji font: {e}")
    # Fallback: Draw green circle (lily pad)
    draw.ellipse([162, 162, 862, 862], fill='#7cb342', outline='white', width=20)

# Save
output_path = 'Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png'
img.save(output_path)
print(f"✅ Icon generated at {output_path}")
PYTHON

else
    echo "❌ Neither ImageMagick nor Python found."
    echo ""
    echo "MANUAL ICON CREATION:"
    echo "1. Open any image editor (Preview, Pixelmator, etc.)"
    echo "2. Create 1024x1024 canvas with green background (#2d5016)"
    echo "3. Add large 🐸 emoji in center"
    echo "4. Save as: frogchat/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
    echo ""
    echo "Or use this online tool:"
    echo "https://www.appicon.co/ (upload any frog image)"
    exit 1
fi
