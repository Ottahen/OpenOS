#!/usr/bin/env python3
"""
OpenOS Clock Widget
A beautiful, glassmorphic clock widget for the desktop
Matches the UI mockup with large time display and cloud background
"""

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('Gdk', '3.0')
from gi.repository import Gtk, Gdk, GLib, Pango, cairo
import datetime
import math

class ClockWidget(Gtk.Window):
    def __init__(self):
        super().__init__(title="OpenOS Clock")

        # Window settings
        self.set_decorated(False)
        self.set_skip_taskbar_hint(True)
        self.set_skip_pager_hint(True)
        self.set_keep_below(True)
        self.set_type_hint(Gdk.WindowTypeHint.DESKTOP)
        self.set_app_paintable(True)

        # Size and position (top-left like in screenshot)
        self.set_default_size(500, 300)
        self.move(50, 50)

        # Make transparent
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual:
            self.set_visual(visual)

        # Main container
        self.overlay = Gtk.Overlay()
        self.add(self.overlay)

        # Drawing area for custom rendering
        self.drawing_area = Gtk.DrawingArea()
        self.drawing_area.set_size_request(500, 300)
        self.drawing_area.connect("draw", self.on_draw)
        self.overlay.add(self.drawing_area)

        # Update every second
        GLib.timeout_add(1000, self.update_time)

        self.current_time = datetime.datetime.now()
        self.show_all()

    def update_time(self):
        self.current_time = datetime.datetime.now()
        self.drawing_area.queue_draw()
        return True

    def on_draw(self, widget, cr):
        width = widget.get_allocated_width()
        height = widget.get_allocated_height()

        # Clear background
        cr.set_source_rgba(0, 0, 0, 0)
        cr.set_operator(cairo.OPERATOR_SOURCE)
        cr.paint()
        cr.set_operator(cairo.OPERATOR_OVER)

        # Draw glassmorphic background
        self.draw_glassmorphic_bg(cr, width, height)

        # Draw time
        self.draw_time(cr, width, height)

        # Draw date
        self.draw_date(cr, width, height)

        # Draw decorative elements
        self.draw_decorations(cr, width, height)

        return False

    def draw_glassmorphic_bg(self, cr, width, height):
        """Draw frosted glass background"""
        # Main rounded rectangle
        corner_radius = 24
        cr.arc(corner_radius, corner_radius, corner_radius, math.pi, 1.5 * math.pi)
        cr.arc(width - corner_radius, corner_radius, corner_radius, 1.5 * math.pi, 2 * math.pi)
        cr.arc(width - corner_radius, height - corner_radius, corner_radius, 0, 0.5 * math.pi)
        cr.arc(corner_radius, height - corner_radius, corner_radius, 0.5 * math.pi, math.pi)
        cr.close_path()

        # Gradient background (dark semi-transparent)
        gradient = cairo.LinearGradient(0, 0, 0, height)
        gradient.add_color_stop_rgba(0, 0.08, 0.08, 0.12, 0.75)
        gradient.add_color_stop_rgba(0.5, 0.06, 0.06, 0.10, 0.70)
        gradient.add_color_stop_rgba(1, 0.04, 0.04, 0.08, 0.65)

        cr.set_source(gradient)
        cr.fill_preserve()

        # Border glow
        cr.set_line_width(1.5)
        cr.set_source_rgba(0.6, 0.5, 0.9, 0.3)
        cr.stroke()

        # Inner highlight
        cr.arc(corner_radius, corner_radius, corner_radius, math.pi, 1.5 * math.pi)
        cr.arc(width - corner_radius, corner_radius, corner_radius, 1.5 * math.pi, 2 * math.pi)
        cr.line_to(width - corner_radius, 2)
        cr.line_to(corner_radius, 2)
        cr.close_path()
        cr.set_source_rgba(1, 1, 1, 0.08)
        cr.fill()

    def draw_time(self, cr, width, height):
        """Draw large time text"""
        time_str = self.current_time.strftime("%I:%M %p")

        # Main time
        cr.set_source_rgba(1, 1, 1, 0.95)
        cr.select_font_face("Inter", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_LIGHT)
        cr.set_font_size(72)

        text_extents = cr.text_extents(time_str)
        x = (width - text_extents.width) / 2
        y = height / 2 - 10

        # Text shadow for depth
        cr.set_source_rgba(0, 0, 0, 0.3)
        cr.move_to(x + 2, y + 2)
        cr.show_text(time_str)

        # Main text
        cr.set_source_rgba(1, 1, 1, 0.95)
        cr.move_to(x, y)
        cr.show_text(time_str)

        # Seconds (smaller)
        seconds_str = self.current_time.strftime("%S")
        cr.set_font_size(28)
        cr.set_source_rgba(0.7, 0.7, 0.9, 0.8)
        sec_extents = cr.text_extents(seconds_str)
        cr.move_to(width - sec_extents.width - 40, y + 15)
        cr.show_text(seconds_str)

    def draw_date(self, cr, width, height):
        """Draw date below time"""
        date_str = self.current_time.strftime("%A, %B %d, %Y")

        cr.set_source_rgba(0.7, 0.7, 0.9, 0.7)
        cr.select_font_face("Inter", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_NORMAL)
        cr.set_font_size(18)

        text_extents = cr.text_extents(date_str)
        x = (width - text_extents.width) / 2
        y = height / 2 + 50

        cr.move_to(x, y)
        cr.show_text(date_str)

    def draw_decorations(self, cr, width, height):
        """Draw subtle decorative elements"""
        # Small dot indicator (like in screenshot)
        cr.arc(width - 30, 30, 4, 0, 2 * math.pi)
        cr.set_source_rgba(0.65, 0.55, 0.95, 0.8)
        cr.fill()

        # Subtle line separator
        cr.move_to(40, height - 60)
        cr.line_to(width - 40, height - 60)
        cr.set_line_width(1)
        cr.set_source_rgba(1, 1, 1, 0.1)
        cr.stroke()

        # Weather hint (placeholder)
        cr.set_source_rgba(0.6, 0.6, 0.8, 0.5)
        cr.set_font_size(14)
        cr.move_to(40, height - 30)
        cr.show_text("☁  Partly Cloudy  •  24°C")

def main():
    # Check if we should run (only on OpenOS)
    if os.environ.get('XDG_CURRENT_DESKTOP', '').lower() not in ['openos', 'gnome', 'cinnamon']:
        print("⚠️  Not running on OpenOS desktop. Exiting.")
        return

    win = ClockWidget()
    win.connect("destroy", Gtk.main_quit)
    Gtk.main()

if __name__ == "__main__":
    import os
    main()
