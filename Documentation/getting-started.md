# Slide Deck — Getting Started (Reveal.js Scaffold)

## Overview
This repository includes a minimal Reveal.js-based scaffold under `slide-deck-236829-236830/Documentation/` that can be used to render and share the slide deck as a simple static website. The slide content itself is currently a placeholder scaffold (`public/index.html`) plus a draft narrative outline (`slide-deck-outline.md`) that still requires topic and audience inputs.

This document explains how to run and build the scaffold, what files matter, and the intended workflow for turning the outline into actual slides.

## What is implemented today
The Documentation workspace contains:
- A Reveal.js web scaffold that serves slides from `public/index.html`.
- A draft slide-by-slide content plan in `slide-deck-outline.md`.
- A checklist of required inputs in `inputs-needed.md`.

The Reveal.js HTML currently contains placeholder slides (“Slide 1”, “Slide 2”) and initializes Reveal with URL hash navigation enabled.

## Folder structure
The relevant paths are:
- `Documentation/public/index.html`: The actual Reveal.js slide document (currently placeholder slides).
- `Documentation/public/css/theme.css`: A minimal CSS override (currently sets the font family).
- `Documentation/scripts/start-server.sh`: Starts a static server using `http-server`.
- `Documentation/package.json`: NPM scripts and the Reveal.js dependency.
- `Documentation/slide-deck-outline.md`: The intended content structure for the final deck.
- `Documentation/inputs-needed.md`: The missing inputs required to finalize the deck.
- `assets/image_01_design_notes.md`: Optional image/color direction notes (reference only).

## Prerequisites
You need:
- Node.js and npm available in your environment.
- Dependencies installed for the Documentation workspace.

From `slide-deck-236829-236830/Documentation`, install dependencies with:
```sh
npm install
```

## Run the slide server locally
The scaffold defines a start script that serves `public/` on port `8000`:
```sh
npm run start
```

### Notes about the server script
The start script calls `scripts/start-server.sh`, which attempts to find `http-server` in one of two places:
1. A globally installed `http-server` on your PATH, or
2. A local `node_modules/.bin/http-server`.

If neither exists or is executable, the script exits with:
`ERROR:scaffold-001:http-server not found`

In that case, install `http-server` locally (dev dependency) or globally. For example, a local install in the Documentation workspace is:
```sh
npm install --save-dev http-server
```

## Build a static artifact
The build script copies `public/` to `dist/`:
```sh
npm run build
```

This produces `Documentation/dist/` containing the static site files.

## How to edit slide content
### Where the slides live
Edit `Documentation/public/index.html`. Reveal.js uses `<section>` elements to define slides. The current file is a minimal placeholder scaffold like:
```html
<div class="reveal"><div class="slides">
  <section>Slide 1<br><small>Generated scaffold</small></section>
  <section>Slide 2</section>
</div></div>
```

### Workflow to convert the outline into slides
1. Use `slide-deck-outline.md` as the authoritative content plan for slide ordering and narrative intent.
2. Collect the missing metadata in `inputs-needed.md` (topic, audience, goal, length, style).
3. Replace the placeholder `<section>` elements in `public/index.html` with the real slide content following the outline sections:
   - Title slide
   - Agenda
   - Problem / Context
   - Key points (3–5 slides)
   - Evidence / Examples
   - Recommendations / Next steps
   - Summary
   - Q&A

## Optional visual direction (image reference)
If you decide to use the provided image reference described in `assets/image_01_design_notes.md`, the outline suggests it could be used as a banner/hero image on the title slide, with an overlay for readability. The design notes also describe an orange-and-charcoal palette that can be used for headings or callouts if it fits the eventual topic and audience.

## Known gaps / open inputs
The deck cannot be finalized without the inputs listed in `inputs-needed.md`. In particular, the topic, audience, and goal determine:
- The claims used on “Key points” slides.
- The selection and framing of “Evidence / Examples”.
- The specificity and decision framing of “Recommendations / Next steps”.

Once those inputs are provided, the HTML slides can be populated directly from the outline.
