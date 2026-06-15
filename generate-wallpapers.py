#!/usr/bin/env python3
"""
OpenOS Wallpaper Generator
Creates the cloud/space wallpaper shown in the UI mockup
"""

from PIL import Image, ImageDraw, ImageFilter, ImageFont
import random
import math

def create_cloud_wallpaper(width=3840, height=2160, output_path="default-cloud.jpg"):
    """Generate a dreamy cloud-space wallpaper matching the UI mockup"""

    # Create base gradient (deep blue night sky)
    img = Image.new('RGB', (width, height), (10, 15, 35))
    draw = ImageDraw.Draw(img)

    # Draw deep space gradient
    for y in range(height):
        # Gradient from deep blue to lighter blue
        r = int(10 + (y / height) * 15)
        g = int(15 + (y / height) * 25)
        b = int(35 + (y / height) * 40)
        draw.line([(0, y), (width, y)], fill=(r, g, b))

    # Add stars
    for _ in range(800):
        x = random.randint(0, width)
        y = random.randint(0, height // 2)
        brightness = random.randint(150, 255)
        size = random.choice([1, 1, 1, 2, 2, 3])

        # Star color (slightly blue-white)
        color = (brightness, brightness, min(255, brightness + 20))

        if size == 1:
            draw.point((x, y), fill=color)
        else:
            draw.ellipse([x-size, y-size, x+size, y+size], fill=color)

    # Add larger glowing stars
    for _ in range(50):
        x = random.randint(0, width)
        y = random.randint(0, height // 2)
        size = random.randint(2, 4)

        # Glow effect
        for i in range(3):
            alpha = int(100 - i * 30)
            glow_size = size + i * 2
            draw.ellipse(
                [x-glow_size, y-glow_size, x+glow_size, y+glow_size],
                fill=(200, 210, 255)
            )

    # Draw soft clouds (the main feature from the screenshot)
    def draw_soft_cloud(draw, cx, cy, size, color):
        """Draw a soft, fluffy cloud using multiple overlapping circles"""
        # Main cloud body
        for i in range(15):
            offset_x = random.randint(-size//2, size//2)
            offset_y = random.randint(-size//4, size//4)
            radius = random.randint(size//3, size//2)

            # Soft edge color
            r, g, b = color
            soft_color = (
                min(255, r + random.randint(10, 30)),
                min(255, g + random.randint(10, 30)),
                min(255, b + random.randint(10, 30))
            )

            draw.ellipse(
                [cx + offset_x - radius, cy + offset_y - radius,
                 cx + offset_x + radius, cy + offset_y + radius],
                fill=soft_color
            )

    # Draw the main cloud cluster (like in the screenshot)
    # Large central cloud
    draw_soft_cloud(draw, width//2, height//3, 400, (100, 140, 200))

    # Smaller surrounding clouds
    draw_soft_cloud(draw, width//2 - 300, height//3 - 50, 250, (80, 120, 180))
    draw_soft_cloud(draw, width//2 + 350, height//3 + 30, 280, (90, 130, 190))
    draw_soft_cloud(draw, width//2 - 150, height//3 + 100, 200, (70, 110, 170))
    draw_soft_cloud(draw, width//2 + 200, height//3 - 80, 220, (85, 125, 185))

    # Add subtle nebula glow (purple/blue like in the screenshot background)
    def add_nebula_glow(img, cx, cy, radius, color):
        """Add a soft nebula glow effect"""
        overlay = Image.new('RGBA', img.size, (0, 0, 0, 0))
        overlay_draw = ImageDraw.Draw(overlay)

        for i in range(radius, 0, -5):
            alpha = int(15 * (1 - i/radius))
            r, g, b = color
            overlay_draw.ellipse(
                [cx - i, cy - i, cx + i, cy + i],
                fill=(r, g, b, alpha)
            )

        img = Image.alpha_composite(img.convert('RGBA'), overlay)
        return img.convert('RGB')

    # Add purple ambient glow (matching the screenshot background)
    img = add_nebula_glow(img, width//2, height//2, 600, (139, 92, 246))  # Purple
    img = add_nebula_glow(img, width//3, height//4, 400, (59, 130, 246))   # Blue
    img = add_nebula_glow(img, 2*width//3, height//3, 350, (167, 139, 250)) # Light purple

    # Apply slight blur for dreamy effect
    img = img.filter(ImageFilter.GaussianBlur(radius=0.5))

    # Save
    img.save(output_path, quality=95)
    print(f"✅ Wallpaper saved: {output_path} ({width}x{height})")
    return output_path

def create_gradient_wallpapers():
    """Create additional gradient wallpapers for theme switching"""

    # Light theme wallpaper (soft white/blue)
    img = Image.new('RGB', (3840, 2160), (240, 245, 250))
    draw = ImageDraw.Draw(img)

    for y in range(2160):
        r = int(240 - (y / 2160) * 20)
        g = int(245 - (y / 2160) * 15)
        b = int(250 - (y / 2160) * 10)
        draw.line([(0, y), (3840, y)], fill=(r, g, b))

    # Add soft clouds for light theme
    for i in range(10):
        cx = random.randint(200, 3640)
        cy = random.randint(200, 1000)
        size = random.randint(150, 300)

        for j in range(8):
            offset_x = random.randint(-size//2, size//2)
            offset_y = random.randint(-size//4, size//4)
            radius = random.randint(size//3, size//2)

            color = (
                random.randint(250, 255),
                random.randint(250, 255),
                random.randint(255, 255)
            )

            draw.ellipse(
                [cx + offset_x - radius, cy + offset_y - radius,
                 cx + offset_x + radius, cy + offset_y + radius],
                fill=color
            )

    img.save("light-cloud.jpg", quality=95)
    print("✅ Light wallpaper saved: light-cloud.jpg")

if __name__ == "__main__":
    import sys

    output_dir = sys.argv[1] if len(sys.argv) > 1 else "."

    create_cloud_wallpaper(output_path=f"{output_dir}/default-cloud.jpg")
    create_gradient_wallpapers()
    print("\n🎨 All wallpapers generated successfully!")
