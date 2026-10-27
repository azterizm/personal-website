#!/bin/sh
# Renders cv-a.html to two text PDFs:
#   out/Abdullah_Memon_CV.pdf             public, no phone (for azterizm.com)
#   private/Abdullah_Memon_CV_portal.pdf  with the phone from $CV_PHONE (never committed)
set -eu
cd "$(dirname "$0")"
CHROME=/Applications/Chromium.app/Contents/MacOS/Chromium
mkdir -p out private
render() { "$CHROME" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="$2" "file://$PWD/$1" 2>/dev/null; }
render cv-a.html out/Abdullah_Memon_CV.pdf
if [ -n "${CV_PHONE:-}" ]; then
  sed "s|<!--PHONE-->|<span>$CV_PHONE</span>|" cv-a.html > private/cv-a-portal.html
  render private/cv-a-portal.html private/Abdullah_Memon_CV_portal.pdf
fi
