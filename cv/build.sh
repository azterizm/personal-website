#!/bin/sh
# Renders each CV to text PDFs:
#   out/Abdullah_Memon_CV.pdf               CV A, public, no phone (for azterizm.com)
#   private/Abdullah_Memon_CV_portal.pdf    CV A with the phone from $CV_PHONE (never committed)
#   out/Abdullah_Memon_CV_B.pdf             CV B (full-stack), no phone. Not on the site yet
#   private/Abdullah_Memon_CV_B_portal.pdf  CV B with the phone from $CV_PHONE (never committed)
#   private/pk-<city>/Abdullah_Memon_CV.pdf and Abdullah_Memon_CV_B.pdf
#                                           Pakistan-role copies with the phone: the role's city as
#                                           the location and no "Remote, UTC+5".
#                                           One folder each for Islamabad, Lahore, Karachi, Faisalabad and Hyderabad
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
pk() { # $1 source html, $2 pdf name. Needs $CV_PHONE
  [ -n "${CV_PHONE:-}" ] || return 0
  for city in Islamabad Lahore Karachi Faisalabad Hyderabad; do
    dir="private/pk-$(printf '%s' "$city" | tr '[:upper:]' '[:lower:]')"
    mkdir -p "$dir"
    sed -e "s|<!--PHONE-->|<span>$CV_PHONE</span>|" \
        -e "s|[A-Za-z]*, Pakistan[^<]*|$city, Pakistan|" \
        -e "s|Deployed the agency's client apps on AWS (Lightsail, then EC2), then moved each product to its own|Responsible for production on the agency's client apps: servers, deployments, databases and incidents, including out-of-hours calls, tracing failures from server logs when users gave no detail. Ran them on AWS (Lightsail, then EC2), then moved each product to its own|" \
        "$1" > "$dir/$1"
    render "$dir/$1" "$dir/$2"
  done
}
build cv-a.html Abdullah_Memon_CV.pdf cv-a-portal.html Abdullah_Memon_CV_portal.pdf
build cv-b.html Abdullah_Memon_CV_B.pdf cv-b-portal.html Abdullah_Memon_CV_B_portal.pdf
pk cv-a.html Abdullah_Memon_CV.pdf
pk cv-b.html Abdullah_Memon_CV_B.pdf
