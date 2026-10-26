---
name: Warm Editorial Sanctuary
colors:
  surface: '#fcf9f4'
  surface-dim: '#dcdad5'
  surface-bright: '#fcf9f4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3ee'
  surface-container: '#f0ede9'
  surface-container-high: '#ebe8e3'
  surface-container-highest: '#e5e2dd'
  on-surface: '#1c1c19'
  on-surface-variant: '#504440'
  inverse-surface: '#31302d'
  inverse-on-surface: '#f3f0eb'
  outline: '#82746f'
  outline-variant: '#d4c3bd'
  surface-tint: '#7a5649'
  primary: '#5f3e32'
  on-primary: '#ffffff'
  primary-container: '#795548'
  on-primary-container: '#fdcdbc'
  inverse-primary: '#ebbcac'
  secondary: '#605e5d'
  on-secondary: '#ffffff'
  secondary-container: '#e5e2e0'
  on-secondary-container: '#666463'
  tertiary: '#603f1a'
  on-tertiary: '#ffffff'
  tertiary-container: '#7b562f'
  on-tertiary-container: '#ffcea0'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbcf'
  primary-fixed-dim: '#ebbcac'
  on-primary-fixed: '#2e150b'
  on-primary-fixed-variant: '#603f33'
  secondary-fixed: '#e5e2e0'
  secondary-fixed-dim: '#c9c6c4'
  on-secondary-fixed: '#1c1b1b'
  on-secondary-fixed-variant: '#484645'
  tertiary-fixed: '#ffdcbd'
  tertiary-fixed-dim: '#eebd8e'
  on-tertiary-fixed: '#2c1600'
  on-tertiary-fixed-variant: '#61401b'
  background: '#fcf9f4'
  on-background: '#1c1c19'
  surface-variant: '#e5e2dd'
typography:
  display-lg:
    fontFamily: Noto Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 44px
  headline-lg:
    fontFamily: Noto Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Noto Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Noto Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 28px
  title-md:
    fontFamily: Noto Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Noto Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 30px
  body-md:
    fontFamily: Noto Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Noto Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Noto Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Noto Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  label-sm:
    fontFamily: Noto Sans
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

The design system establishes a quiet, reflective sanctuary for daily reading habits. Built around an editorial Arabic aesthetic, it balances classical warmth with the refined precision of Material Design 3. The interface evokes the tactile, calming sensation of opening a linen-bound book on a sunlit afternoon—inviting contemplation, consistency, and focus without digital friction.

### Visual Aesthetic & Movement
- **Editorial Minimalism:** Strips away non-essential chrome to emphasize typography, generous margins, and warm negative space.
- **Warm Tactility:** Replaces cold, high-tech surfaces with paper-inspired creamy tones, organic ochres, and deep espresso inks.
- **RTL-First Symmetry:** Interfaces are naturally mirrored for Arabic typography and flow, ensuring optical balance, natural eye-tracking from right-to-left, and intuitive navigation.
- **Micro-Interactions:** Subtle, intentional state transitions mirroring tactile feedback (e.g., subtle card lifts and gentle, warm focus highlights).

## Colors

The palette is tuned around high-legibility, low-strain, long-session reading. It relies on subtle contrast steps derived from natural parchment and earthen pigments.

### Functional Roles & Flutter Theme Mapping
- **Primary (`#795548`):** Deep earthy umber. Serves as the primary brand action color, active tab indicators, and primary CTA backgrounds.
- **Secondary / Container (`#EFEBE9`):** Soft beige. Provides grounding for inactive controls, secondary button fills, and pill indicators.
- **Tertiary (`#A67C52`):** Warm caramel. Applied to reading progress streaks, bookmark highlights, badge tags, and celebratory habit rings.
- **Background / Canvas (`#FAF7F2`):** Warm ivory. Reduces blue-light eye fatigue during prolonged reading sessions.
- **Surface / Card (`#FFFDF9`):** Elevated soft cream surface, ensuring subtle distinction against the background canvas without sharp contrast.
- **On-Surface / Text Primary (`#332820`):** Deep roasted walnut. Ensures WCAG AAA compliance against ivory surfaces without the harsh starkness of pure black `#000000`.
- **On-Surface Variant / Text Secondary (`#786E65`):** Muted stone. Applied for secondary metadata, author names, reading timestamps, and inactive labels.
- **Outline / Border (`#D8CEC3`):** Delicate parchment line. Used for ultra-subtle 1dp card borders, dividers, and empty state containers.
- **Success (`#4F7255`):** Sage moss green. Used for completed daily goals, habit checkboxes, and reading milestones.
- **Error (`#BA4A42`):** Terracotta crimson. Non-jarring, legible error alerts, overdue reading targets, and validation warnings.

## Typography

Typography relies on `Noto Sans Arabic` across all hierarchies. In Arabic script, diacritics and tall ascenders require generous line-height ratios (minimum 1.5x–1.65x) to maintain breathability and avoid clipping.

### Editorial Hierarchies & Legibility Rules
- **Display & Headlines:** Weight 600–700. Used for milestone stats, book titles, and page headers. Zero or slight positive letter-spacing (Arabic typography avoids tracking expansion).
- **Reading Body (`body-lg` / `body-md`):** Weight 400 with 30px line height on 18px text for long-form passages. Guarantees legible ligatures and diacritic rendering.
- **Labels & Badges (`label-lg` down to `label-sm`):** Weight 500–600. Applied for navigation targets, metadata badges, progress percentages, and chapter subheads.

## Layout & Spacing

The layout is optimized for single-hand mobile interactions built atop Flutter's standard 8dp spatial rhythm.

### Grid & Ergonomic Guidelines
- **Screen Padding:** Standard horizontal margin of 16dp (`margin`), providing edge breathing room for thumb scrolling.
- **Rhythm Multiples:** All dimensions, margins, paddings, and vertical spacings are strictly multiples of 4dp/8dp:
  - `space-xs` (4dp): Micro-gaps between badge icons and text labels.
  - `space-sm` (8dp): Inner chip padding, tight list item gaps.
  - `space-md` (16dp): Standard card internal padding, vertical layout spacing.
  - `space-lg` (24dp): Section separators, hero card internal spacing.
  - `space-xl` (32dp): Header spacing, top safe-area offsets.
- **Touch Target Enforcements:** Every tappable target (app bar icons, bottom nav items, check circles, list action items) must measure at least 48dp × 48dp.
- **Responsive Adaptations:**
  - *Mobile (< 600dp):* Single-column vertical stream, persistent bottom navigation.
  - *Tablet / Foldable (≥ 600dp):* Dynamic 2-column masonry grid for book covers and habits; navigation reflows into a leading `NavigationRail`.

## Elevation & Depth

To preserve an airy, serene editorial feeling, elevation relies primarily on tonal separation and soft, warm ambient shadows rather than stark directional drops.

### Elevation Architecture
- **Level 0 (Background Canvas):** Pure `#FAF7F2`.
- **Level 1 (Card & Content Surface):** `#FFFDF9` paired with an ultra-soft ambient shadow:
  - *Box Shadow:* `0px 4px 16px rgba(51, 40, 32, 0.04)`.
  - *Outline:* 1dp border tinted with `#D8CEC3` at 60% opacity to preserve crisp card separation without heaviness.
- **Level 2 (Dropdowns, Floating Actions, Bottom Sheet):** `#FFFDF9` with elevated warmth:
  - *Box Shadow:* `0px 8px 24px rgba(51, 40, 32, 0.08)`.
- **Level 3 (Modals & Overlays):** `#FFFDF9` centered on a dimmed barrier of `rgba(51, 40, 32, 0.35)`.
- **Surface Tinting:** Material Design 3 surface tinting is restricted to a maximum 2% blend of `#795548` to avoid discolouring the cream background.

## Shapes

The shape system blends structured discipline with soft curves that feel friendly and tactile.

### Shape Tokens & Flutter Application
- **Base Components (Inputs, Chips, Buttons):** `8dp` to `12dp` (Smooth, refined corners).
- **Cards & Reading Modules:** Standard cards use `16dp` radii (`RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))`). Large showcase and daily streak summary cards use `24dp` radii.
- **Bottom Navigation & Sheets:** Top corners curved at `24dp` (`BorderRadius.vertical(top: Radius.circular(24))`).
- **Interactive Habit Checkers:** Circular (`32dp` pill or full circle `BorderRadius.circular(999)`).

## Components

### Buttons
- **Primary Elevated Button:** Fill `#795548`, text `#FAF7F2` (`label-lg`), height 52dp, radius 12dp. Pressed state shifts to `#5D4037`.
- **Secondary / Outlined Button:** Transparent fill, 1.5dp border `#795548`, text `#795548`.
- **Text Action:** Color `#A67C52`, minimum 48dp tap bounds.

### Cards
- **Habit & Book Progress Card:** Background `#FFFDF9`, border 1dp `#D8CEC3`, border radius 16dp, padding 16dp. Includes horizontal layout: Book thumbnail (RTL right-aligned), Title & author stack, linear habit progress indicator in `#A67C52`, and check action.
- **Featured Quote / Daily Target Card:** Border radius 24dp, soft gradient fill from `#FFFDF9` to `#EFEBE9`, subtle caramel quote accent mark.

### Chips & Badges
- **Category & Genre Chips:** Height 36dp, radius 18dp. Unselected: surface `#EFEBE9`, text `#786E65`. Selected: surface `#795548`, text `#FAF7F2`.
- **Streak & Counter Badge:** Background `rgba(166, 124, 82, 0.12)`, text `#A67C52`, bold weight.

### Form Fields & Search
- **Search & Log Text Field:** Fill `#FFFDF9`, border 1dp `#D8CEC3`, active border 1.5dp `#795548`. Rounded 12dp. Content padding: 16dp horizontal, 14dp vertical. Placeholder in `#786E65`. Prefix search icon positioned on the right for Arabic RTL flow.

### Checkboxes & Habit Trackers
- **Daily Reading Check Target:** 28dp circle, border 2dp `#D8CEC3`. When checked: fill `#4F7255`, border `#4F7255`, inner check icon in `#FFFDF9`. Smooth 200ms scale transition on tap.

### NavigationBar (Material 3)
- **Container:** Height 80dp, background `#FAF7F2`, top border 1dp `#D8CEC3`.
- **Active Indicator:** Pill indicator (`#EFEBE9`), icon color `#795548`.
- **Inactive Destinations:** Icon color `#786E65`, label `#786E65`.
- **Destinations (Ordered Right-to-Left):**
  1. **الرئيسية** (Home / Today's Reading)
  2. **المكتبة** (Library / My Books)
  3. **المجموعات** (Reading Circles / Groups)
  4. **إنجازاتي** (My Streaks & Achievements)