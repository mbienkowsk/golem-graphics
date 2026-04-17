# golem-graphics

Generates promotional graphics for Golem AI Society lectures. Define a single YAML file per lecture and run one command to produce images sized for Discord, Facebook, Instagram, and Full HD.

## Usage

### With the Nix dev shell (recommended)

All dependencies and fonts bundled, generate images with a single command. First ![install the nix package manager](https://nixos.org/download/), then:

```sh
nix develop
just all <directory with config.yaml (see below)>
```

Or generate a single format:

```sh
just discord <directory with config.yaml>
just instagram <directory with config.yaml>
```

Outputs land in the lecture directory: `directory/discord.png`, etc.

### Without Nix

Install dependencies manually:

```sh
# Typst
sudo apt install typst

# just
sudo apt install just

# Fonts (Arial is required)
sudo apt install ttf-mscorefonts-installer fontconfig
sudo fc-cache -f
```

Then run the same `just` commands as above.

## Adding a new lecture

Create a directory and a `config.yaml` inside it:

```
lectures/
  18/
    config.yaml
```

Example configuration:

```yaml
# lectures/18/config.yaml
heading: "Golem #18"
title: "Your talk title here"
author: Dr. Pepper
date: 16 kwietnia 2026
place: WEiTI, aula 133
time: 18:15
```

Run:

```sh
just all lectures/18
```

## Architecture

```
layouts/          # one YAML per output format, defines dimensions and text layout
assets/           # background images, one per format
lectures/         # one directory per lecture, contains config.yaml and generated PNGs
main.typ          # Typst template, shared across all formats
Justfile          # build commands
```

Each `just` recipe calls `typst compile` with two inputs: the layout YAML for the target format and the lecture's `config.yaml`. The template places text on top of a background image according to the layout parameters.

## Layouts

Layout files live in `layouts/` and control everything about a format's output. The current formats and their output resolutions:

| Format     | Size (in)  | PPI | Output (px)  |
|------------|------------|-----|--------------|
| discord    | 10 x 4     | 80  | 800 x 320    |
| facebook   | 10 x 5.25  | 144 | 1440 x 756   |
| instagram  | 10 x 10    | 108 | 1080 x 1080  |
| full_hd    | 10 x 5.625 | 192 | 1920 x 1080  |

### Layout YAML fields

```yaml
bg: assets/discord.png      # background image

width_inches: 10            # page width in inches
height_inches: 4            # page height in inches
ppi: 80                     # pixels per inch

text_boundaries:
  left: 3                   # left edge of text area, as % of page width
  right: 49                 # right edge of text area, as % of page width

fontsizes:
  heading: 30               # "Golem #17" label, in pt
  title_name: 15            # talk title and speaker name, in pt
  time_place: 20            # date, venue, time block, in pt

y_offsets_px:
  heading: 40               # distance from top of image, in px
  title: 85
  author: 140
  date_place: 210

line_spacing_em:
  title: 0.3                # extra leading between title lines
  date_place: 0.8           # extra leading between date/place/time lines
```

`text_boundaries.left` and `.right` are percentages of the page width (0-100). `y_offsets_px` values are raw pixels from the top of the image; the total image height in pixels is `height_inches * ppi`.

### Adding a new format

1. Add a background image to `assets/`.
2. Create `layouts/yourformat.yaml`.
3. Add a recipe to the `Justfile`:

```just
yourformat arg:
  typst compile main.typ --format png --ppi <ppi> \
    --input cfg={{arg}}/config.yaml \
    --input layout=layouts/yourformat.yaml \
    {{arg}}/yourformat.png
```

Note that `ppi` appears in two places: the `--ppi` flag passed to the compiler, and the `ppi` field in the layout YAML. They must match. The template uses the YAML value to convert pixel offsets to page-relative positions; the compiler uses the flag to rasterize the output.

### Getting dimensions right

Typst does not work in pixels directly. Resolution is controlled by `ppi * width_inches`. A good starting point for a new layout:

1. Fix `width_inches = 10`. This keeps font sizes consistent across formats.
2. Choose your target pixel resolution and derive `ppi = target_width_px / 10`.
3. Calculate `height_inches = target_height_px / ppi`.

If you scale `width_inches` or `height_inches` up significantly (e.g. 2x), fonts will appear tiny relative to the canvas and you will need very large point values to compensate. Keeping `width_inches = 10` as the anchor makes font sizes predictable and easy to tune.
