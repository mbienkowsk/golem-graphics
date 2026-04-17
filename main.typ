#let layout_cfg = yaml(sys.inputs.layout)

// page params
#let PAGE_WIDTH_INCHES = layout_cfg.width_inches
#let PAGE_HEIGHT_INCHES = layout_cfg.height_inches
#let PPI = layout_cfg.ppi
#let PAGE_WIDTH_PX = PAGE_WIDTH_INCHES * PPI
#let PAGE_HEIGHT_PX = PAGE_HEIGHT_INCHES * PPI

// fontsizes
#let FONTSIZE_HEADING = layout_cfg.fontsizes.heading * 1pt
#let FONTSIZE_SMALL = layout_cfg.fontsizes.title_name * 1pt
#let FONTSIZE_DATE_PLACE = layout_cfg.fontsizes.time_place * 1pt

// unwrap text constants
#let TEXT_LEFT_BOUNDARY = layout_cfg.text_boundaries.left
#let TEXT_RIGHT_BOUNDARY = layout_cfg.text_boundaries.right
#let TEXTBOX_WIDTH = (TEXT_RIGHT_BOUNDARY - TEXT_LEFT_BOUNDARY) * 1%

#let TITLE_LINE_SPACING = layout_cfg.line_spacing_em.title * 1em
#let DATE_PLACE_LINE_SPACING = layout_cfg.line_spacing_em.date_place * 1em

// match page size to input png
#set page(
  width: PAGE_WIDTH_INCHES * 1in,
  height: PAGE_HEIGHT_INCHES * 1in,
  margin: 0em,
)

#set text(font: "Arial", fill: rgb("4d4a65"))

#let contents_cfg = yaml(sys.inputs.config-path)

#image(layout_cfg.bg, width: 100%)

#let place_text(y, size, body) = [
  #place(
    top + left,
    dx: TEXT_LEFT_BOUNDARY * 1%,
    dy: (y / PAGE_HEIGHT_PX) * 100%,
  )[
    #box(width: TEXTBOX_WIDTH)[#text(body, size: size)]
  ]
]

#place_text(
  layout_cfg.y_offsets_px.heading,
  FONTSIZE_HEADING,
  contents_cfg.heading,
)

#place_text(
  layout_cfg.y_offsets_px.title,
  FONTSIZE_SMALL,
  par(leading: TITLE_LINE_SPACING)[#contents_cfg.title],
)

#place_text(
  layout_cfg.y_offsets_px.author,
  FONTSIZE_SMALL,
  contents_cfg.author,
)

#place_text(
  layout_cfg.y_offsets_px.date_place,
  FONTSIZE_DATE_PLACE,
  [
    #par(leading: DATE_PLACE_LINE_SPACING)[
      #contents_cfg.date
      #linebreak()
      #contents_cfg.place
      #linebreak()
      #contents_cfg.time
    ]
  ],
)
