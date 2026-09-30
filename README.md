# Cipher Lens

Offline decoder/encoder for SOC analysts. One file (`index.html`), no dependencies, no network calls.

## Host on GitHub Pages
1. Create a repo and commit `index.html` (and this README).
2. Settings > Pages > deploy from the `main` branch, root folder.
3. Open the published URL.

## Security notes
- Public GitHub Pages sites are readable by anyone. Use a private/internal Pages plan or an internal web server if the tool itself must not be public.
- Data never leaves the tab. The page's Content-Security-Policy meta tag blocks network requests, but GitHub Pages cannot send real security headers, so treat the meta tag as defence in depth.
- Only the "Alternative tools" links go off-site. Delete that section if your policy requires zero outbound links.
- Record the approved version: `sha256sum index.html`. Re-check after every change.
- Findings, MITRE tags and the triage hint are heuristics. Confirm in your EDR/SIEM.

## Supported
Decode + encode: Base64 (+URL-safe, Gzip/zlib, UTF-16LE), Base32, Hex, URL, Unicode/`\x`, HTML entities, char codes, Binary, ROT13, Reverse, XOR (key), JWT (decode).
Decode only: XOR brute-force (1 byte), PowerShell de-obfuscation (backticks, string concatenation, `[char]`).
Encode only: PowerShell `-EncodedCommand`, Gzip + Base64.
Decode mode is for a single encoded value. Batch mode accepts values only from a `.txt` file (one value per line, up to 500 values, max 2 MB): click Upload .txt file or drop the file onto the input. Pasting is disabled in Batch mode. Each value is decoded through all layers, given a triage hint and indicator counts, and indicators are aggregated across values. Click a row to open it in the main panels. Export CSV or JSON, or copy all IOCs defanged. CSV cells that start with `=`, `+`, `-` or `@` are prefixed with `'` to prevent spreadsheet formula injection.
Files: open or drag a file onto the input (max 5 MB; binary files load as hex).

## Not yet included
Base58/Base85, raw deflate, multi-byte XOR key recovery, hex-dump view, Web Worker for very large inputs, user-editable detection rules.
