# Taskerer design system

Single source of truth for typography, color, and reusable marketing layouts. **Inter** is the only UI typeface; prefer theme and helpers over ad-hoc `TextStyle`s.

## Typography (Inter)

| Role | Use | Implementation |
|------|-----|----------------|
| **Heading** | Screen titles, hero headlines | `Theme.of(context).textTheme.displaySmall`, `headlineMedium`, or `AppTypography.heading(color)` |
| **Subheading** | Section titles, emphasis under headings | `titleLarge` / `titleMedium`, or `AppTypography.subheading(color)` |
| **Body** | Primary copy, labels on controls | `bodyLarge` / `bodyMedium`, or `AppTypography.body(color)` |
| **Small / secondary** | Legal, hints, meta, footers | `bodySmall`, `labelSmall`, or `AppTypography.smallSecondary(color)` |

**Code entry points**

- `lib/app/core/theme/app_theme.dart` — `TextTheme` built with `GoogleFonts.inter` (light + dark).
- `lib/app/core/theme/app_typography.dart` — `AppTypography` + `AppTypography.fromContext(context)` for semantic access.

Do **not** set `fontFamily` to Nunito or other families on new screens.

## Color (5 core roles)

| Role | Light | Dark (where different) | Constants |
|------|-------|-------------------------|-----------|
| Brand / primary | `#1867E9` | same | `AppColors.brandPrimary` (= `primaryColor`) |
| Accent (links, gradients) | `#2A9FFB` | same | `AppColors.brandAccent` (= `accentBlue`) |
| Surface / background | `#FFFFFF` / `#F0F4FA` scaffold | `#080D1A` / `#0E1525` | `AppColors.surface`, `backgroundLight`, `card`, `darkSurface` |
| On-surface (main text) | `#0C1A3A` | `#E6EAF2` | `textPrimary`, `darkTextPrimary`, `onSurface` |
| Muted / borders | `#A0AABF`, `#E2E8F4` | `#5A6480`, dark borders | `textMuted`, `borderDefault`, `darkTextMuted` |

**Semantic / feedback** (keep rare): `semanticError` (red), `green`, `gold` — only for states, not chrome.

Legacy names (`primaryColor`, `borderLight`, …) remain for existing files; **new** code should prefer the roles above.

## Marketing / auth layout

**Widget:** `MarketingShellLayout` — `lib/app/core/widgets/marketing_shell_layout.dart`

Structure: **header** (start-aligned) → **hero** (center) → **actions** (full-width column) → optional **footer**.

**Variants:** `MarketingShellDensity.comfortable` (default) vs `.compact` — use density for spacing, not a second layout widget.

## User-supplied media

Drop shared assets under:

- `assets/user_media/images/`
- `assets/user_media/videos/`

Register new subfolders in `pubspec.yaml` if you add directories. Reusable paths: `lib/app/core/const/user_assets.dart` (`UserAssets`).

## Buttons

- Primary gradient: `GradientButton` (default height **44** logical px via ScreenUtil).
- Outlined social: `SocialButton` (default height **44**).

Adjust bulk via widget parameters; avoid one-off copies of the same button chrome.

---

When adding screens similar to welcome/onboarding hero flows, **reuse** `MarketingShellLayout` and theme text styles. If a variation is needed, add a parameter or `MarketingShellDensity`, not a parallel screen layout.
