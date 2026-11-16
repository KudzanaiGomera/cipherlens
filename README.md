# Cipher Lens

Offline decoder/encoder for SOC analysts. One file (`index.html`), no dependencies, no network calls.

Use **Defang URLs** to convert URLs in pasted text into documentation-safe forms such as `hxxps://example[.]com/path`. **Refang URLs** restores `http(s)://` and `[.]` in defanged URLs. **Remove URL spaces** removes `%20` from URLs. Each transformed result appears in the output pane for copying. IOC copy and Markdown report actions also provide defanged indicators.

Additional investigation tools:
- **URL breakdown** parses detected URLs locally into scheme, host, port, path, query and fragment. It never opens or contacts a URL.
- **Extract IOCs** puts the unique indicators from the current output into a copyable list. Export indicators as CSV or STIX 2.1, or create a Markdown report.
- **Local file hashes** calculates MD5, SHA-1 and SHA-256 for files opened in the app. Files stay in the browser; the normal file size limit applies.
- **Batch URL transforms** defangs, refangs or removes `%20` from every non-empty line in a batch file, with a copyable result list.
- **Session snapshots** save the current decode stack, batch results and history in browser storage so you can restore an investigation later without leaving the tab.

## Planned
Optional AI assistance may be added later to explain selected decoded content or summarize indicators. It would require an external AI service, so CipherLens would clearly disclose what text is sent and ask for confirmation before each request. AI assistance is not currently implemented; the app remains offline and processes data locally.

## Host on GitHub Pages
1. Create a repo and commit `index.html` (and this README).
2. Settings > Pages > deploy from the `main` branch, root folder.
3. Open the published URL.

## Deploy to Cloudflare Pages

1. Install Node.js and authenticate with Cloudflare:

   ```powershell
   npx.cmd --yes wrangler@4 login --use-keyring
   ```

2. Create a Cloudflare Pages project named `cipherlens`:

   ```powershell
   npx.cmd --yes wrangler@4 pages project create cipherlens
   ```

   Select `main` as the production branch if prompted.
3. From the repository root, deploy the frontend:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\deploy-pages.ps1
   ```

   The script stages and uploads only `index.html` to the `cipherlens` Pages project. To use a differently named project, pass `-ProjectName your-project-name`.
4. Open the `*.pages.dev` URL shown by Wrangler. Future updates can be published by rerunning the deploy command.

## Deploy to Cloudflare Workers
The Wrangler config serves assets from the repository root, and `.assetsignore` ensures only `index.html` is uploaded. This avoids relying on a generated folder that is not present in Cloudflare Workers Builds. The repository includes a PowerShell deploy script for local deployments; from the repository root, run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\deploy.ps1
```

The script deploys the `cipherlens` Worker. On first use, authenticate with `npx.cmd --yes wrangler@4 login --use-keyring`. To validate without deploying, add `-DryRun` to the PowerShell command.

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
