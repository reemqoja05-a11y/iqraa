---
name: Warm Editorial Serenity
colors:
  surface: '#fff8f5'
  surface-dim: '#f5d3c1'
  surface-bright: '#fff8f5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff1ea'
  surface-container: '#ffeadf'
  surface-container-high: '#ffe3d4'
  surface-container-highest: '#fedcc9'
  on-surface: '#29170d'
  on-surface-variant: '#50443e'
  inverse-surface: '#402c20'
  inverse-on-surface: '#ffede5'
  outline: '#83746d'
  outline-variant: '#d5c3ba'
  surface-tint: '#7d553e'
  primary: '#51301b'
  on-primary: '#ffffff'
  primary-container: '#6b4630'
  on-primary-container: '#e9b699'
  inverse-primary: '#efbc9f'
  secondary: '#556435'
  on-secondary: '#ffffff'
  secondary-container: '#d6e7ac'
  on-secondary-container: '#5a6839'
  tertiary: '#4c3400'
  on-tertiary: '#ffffff'
  tertiary-container: '#694900'
  on-tertiary-container: '#efb853'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbc9'
  primary-fixed-dim: '#efbc9f'
  on-primary-fixed: '#2f1404'
  on-primary-fixed-variant: '#623e29'
  secondary-fixed: '#d9e9ae'
  secondary-fixed-dim: '#bdcd94'
  on-secondary-fixed: '#151f00'
  on-secondary-fixed-variant: '#3e4c20'
  tertiary-fixed: '#ffdeaa'
  tertiary-fixed-dim: '#f5bd58'
  on-tertiary-fixed: '#271900'
  on-tertiary-fixed-variant: '#5f4100'
  background: '#fff8f5'
  on-background: '#29170d'
  surface-variant: '#fedcc9'
typography:
  headline-lg:
    fontFamily: Noto Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: 0px
  body-lg:
    fontFamily: Noto Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 28px
    letterSpacing: 0px
  body-md:
    fontFamily: Noto Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0px
  label-md:
    fontFamily: Noto Sans
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.5rem
  space-sm: 0.75rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.5rem
---

## Brand & Style

This design system establishes a tranquil, distraction-free digital sanctuary tailored for immersive Arabic reading and habit retention. It blends timeless bookmaking craft with modern tactile digital interfaces. 

The emotional tone evokes calm focus, dignity, and intellectual comfort—akin to sitting with a well-bound book in afternoon sunlight. By deliberately omitting harsh pure black (#000000) and utilitarian neutral grays, the system leans into earthy, tactile warmth using graduated brown tones and vegetable-dye olive tints. 

Stylistically, the interface pairs **Minimalist Editorial** restraint with **Tactile/Tonal Depth**:
- **Right-to-Left (RTL) First**: Natural visual hierarchy, balance, and spatial flow tuned specifically for the Arabic reading path.
- **Supportive, Non-Punitive Philosophy**: Missed reading goals or catch-ups eschew alarming reds or aggressive notifications, relying instead on a gentle, nurturing Warm Amber tone for guidance and continuity ("تدارك واستمر").
- **Generous Breathability**: Deliberate negative space and comfortable margins respect long-form Arabic typography, preventing cognitive fatigue during prolonged reading sessions.

## Colors

The palette rejects standard monochrome grayscale entirely. All structural, textual, and surface levels are composed from calibrated brown and olive progressions to ensure natural warmth and reduce eye strain.

### Brown Scale (Primary & Surfaces)
- **Cream 50 (`#FBF6EE`)**: Universal scaffold and background surface. Replaces stark paper white with an organic, sun-bleached parchment tint.
- **Brown 100 (`#F1E4D3`)**: Elevated container and card surface tone.
- **Brown 300 (`#CDAA85`)**: Subtle decorative rules, borders, and inactive progress tracks.
- **Brown 500 (`#9A6B48`)**: Active tab indicators, primary illustrative accents, and prominent icon states.
- **Brown 700 (`#6B4630`)**: Primary interactive color; base tone for full-width action buttons and focused structural nodes.
- **Brown 900 (`#3E2A1E`)**: Primary reading text, titles, and high-contrast structural headings (achieves ≥ 7:1 against Cream 50).

### Olive Scale (Secondary, Metadata & Functional)
Replaces standard gray scales across the entire product.
- **Olive 100 (`#E6EBD3`)**: Chip backgrounds, reading progress highlights, and soft actionable badges.
- **Olive 300 (`#B5BF8E`)**: Hairline borders, structural dividers, and secondary component contours.
- **Olive 500 (`#7A8A4B`)**: Inactive tab icons, secondary glyphs, and auxiliary indicators.
- **Olive 700 (`#4F5D2F`)**: Secondary metadata, author tags, timestamps, and secondary buttons (guarantees WCAG AA ≥ 4.5:1).
- **Olive 900 (`#2F3A1F`)**: Deep olive contrast for dark-mode text accents or dense secondary tables.

### Accents
- **Warm Amber (`#D9A441`)**: Reserved exclusively for restorative touchpoints—such as gentle "تدارك واستمر" (catch up and continue) reading prompts. Never used to penalize, alert, or induce urgency.

## Typography

The typography leverages **Noto Sans** (configured for RTL Arabic scripts), prioritizing clarity, proportional open counters, and high legibility across varied mobile viewports.

### Screen Hierarchy Constraint
To preserve cognitive calm, **no single view may employ more than three distinct type sizes**:
1. **Title / Headline (`22px` / `32px` line-height)**: Applied to chapter headings, screen titles, and modal headers. Uses weight `700` with generous line-height to accommodate Arabic ascenders and diacritics.
2. **Body Text (`16px` or `14px`)**:
   - `16px` / `28px` line-height: Primary narrative reading, quotes, and primary form inputs.
   - `14px` / `24px` line-height: Secondary descriptions, card descriptions, and list item body.
3. **Caption & Metadata (`13px` / `20px` line-height)**: Reserved for tags, auxiliary stamps, verse counts, reading time estimates, and micro-labels. Weight `500` ensures crisp rendering at compact scales.

Letter-spacing must remain strictly `0` across all Arabic text levels to avoid disrupting glyph joins and traditional ligature harmony.

## Layout & Spacing

The layout is built on a mobile-first fluid single-column framework with RTL mirroring across all directional properties.

- **Screen Margins**: Default to `1.25rem` (20px) on mobile viewports, scaling between `1rem` (16px) on compact devices and `1.5rem` (24px) on larger handheld devices.
- **Component Gutters and Gaps**: Inter-card and inter-element spacing follows a strict rhythm of `0.75rem` (12px) to `1rem` (16px).
- **RTL Alignment Rules**:
  - Primary text anchors strictly to the right edge.
  - Progress bars, list chevrons, and backward navigation indicators flip symmetrically (`chevron-left` functions as forward progression, `chevron-right` navigates back).
  - Floating action buttons and badge indicators anchor to the visual start (top-right or bottom-right depending on orientation).
- **Touch Ergonomics**: All interactive elements (icon buttons, list selections, reading triggers) maintain an absolute minimum touch zone of **48×48dp**, regardless of visible graphic size.

## Elevation & Depth

This system avoids stark, cold drop shadows. Depth is achieved primarily through warm tonal layering and soft ambient occlusion.

- **Surface Tiering**:
  - **Base Canvas**: Cream 50 (`#FBF6EE`).
  - **Surface Level 1 (Cards, Sheets, Bars)**: Brown 100 (`#F1E4D3`) over base, demarcated by a soft, warm perimeter outline rather than hard shadows.
  - **Surface Level 2 (Floating Sheets, Dialogs)**: Brown 100 (`#F1E4D3`) accompanied by a diffused, warm-tinted shadow: `box-shadow: 0 8px 24px rgba(62, 42, 30, 0.08)`.
- **Subtle Boundaries**: When separation is required without increasing elevation, use a hairline border (`1px solid #CDAA85` at 40% opacity or `#B5BF8E` at 50% opacity).
- **Tactile Transitions**: Primary buttons use a subtle vertical tonal gradient from Brown 700 (`#6B4630`) to Brown 900 (`#3E2A1E`) to suggest physical weight and texture without mimicking dated skeuomorphism.

## Shapes

The shape system adopts a unified **16px (`1rem`) border-radius** across all major interactive and structural components.

- **Cards and Dialogs**: Uniform `16px` radius. Creates a handheld, organic silhouette reminiscent of smooth, rounded paper blocks.
- **Buttons and Inputs**: Fixed `16px` corner radius. Maintains harmony with card boundaries.
- **Micro-Chips and Badges**: Fully rounded pill shapes (`9999px`) to create clear differentiation between actionable containers (cards) and compact informational tags (chips).

## Components

### Buttons
- **Primary Action (Singular Dominance)**:
  - Exactly one visually dominant primary button per screen.
  - Full-width, 52px height, 16px radius, minimum 48x48dp interactive bounding box.
  - Styled with a subtle gradient from Brown 700 (`#6B4630`) to Brown 900 (`#3E2A1E`) with high-contrast Cream 50 (`#FBF6EE`) text (`16px`, weight 700).
- **Secondary Action**:
  - Outlined with 1.5px Olive 300 (`#B5BF8E`), Olive 700 (`#4F5D2F`) text, and transparent background.
- **Tertiary / Ghost Action**:
  - Borderless, Olive 700 (`#4F5D2F`) text with subtle Olive 100 (`#E6EBD3`) hover/pressed ripple.

### Cards
- Constructed with Brown 100 (`#F1E4D3`) surface fill, 16px border radius, and internal padding of 16px or 20px.
- Border: Optional 1px hairline in Brown 300 (`#CDAA85`) at 30% opacity.
- Headings inside cards use Brown 900 (`#3E2A1E`), supporting metadata uses Olive 700 (`#4F5D2F`).

### Chips & Badges
- Pill-shaped (`rounded-full`), 32px height, horizontal padding of 12px.
- Background: Olive 100 (`#E6EBD3`) with Olive 700 (`#4F5D2F`) label text (`13px`, weight 500).
- Selected state flips to Brown 700 (`#6B4630`) background with Cream 50 (`#FBF6EE`) text.

### Restorative Prompt ("تدارك واستمر")
- A dedicated, non-punitive card for catching up on missed readings.
- Soft Warm Amber background tint (`#D9A441` at 12% opacity) paired with a 1px border in Warm Amber (`#D9A441` at 40% opacity).
- Iconography and emphasis text render in Warm Amber (`#D9A441`). No red, warning triangles, or negative phrasing permitted.

### Form Inputs
- 52px height, 16px radius, background in Cream 50 (`#FBF6EE`) nested inside Brown 100 surfaces or vice versa.
- Border: 1.5px Olive 300 (`#B5BF8E`). Focus state transitions border to Brown 700 (`#6B4630`) with zero external glow.
- Right-aligned text input with placeholder in Olive 500 (`#7A8A4B`).

### Lists & Dividers
- List items span full width with 12px to 16px vertical padding.
- Dividers: Inset hairline dividers using Olive 300 (`#B5BF8E`) at 40% opacity, terminating 16px before the right and left margins.
- Trailing navigational arrows point to the left (`chevron-left`) representing RTL progression.