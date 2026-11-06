#!/bin/sh
# Renders each CV to two text PDFs:
#   out/Abdullah_Memon_CV.pdf               CV A, public, no phone (for azterizm.com)
#   private/Abdullah_Memon_CV_portal.pdf    CV A with the phone from $CV_PHONE (never committed)
#   out/Abdullah_Memon_CV_B.pdf             CV B (full-stack), no phone. Not on the site yet
#   private/Abdullah_Memon_CV_B_portal.pdf  CV B with the phone from $CV_PHONE (never committed)
set -eu
cd "$(dirname "$0")"
CHROME=/Applications/Chromium.app/Contents/MacOS/Chromium
mkdir -p out private
render() { "$CHROME" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="$2" "file://$PWD/$1" 2>/dev/null; }
build() { # $1 source html, $2 public pdf, $3 portal html, $4 portal pdf
  render "$1" "out/$2"
  if [ -n "${CV_PHONE:-}" ]; then
    sed "s|<!--PHONE-->|<span>$CV_PHONE</span>|" "$1" > "private/$3"
    render "private/$3" "private/$4"
  fi
}
build cv-a.html Abdullah_Memon_CV.pdf cv-a-portal.html Abdullah_Memon_CV_portal.pdf
build cv-b.html Abdullah_Memon_CV_B.pdf cv-b-portal.html Abdullah_Memon_CV_B_portal.pdf
