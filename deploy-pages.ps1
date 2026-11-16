param(
    [string]$ProjectName = 'cipherlens'
)

$ErrorActionPreference = 'Stop'
$assetsPath = Join-Path $PSScriptRoot '.pages-assets'

Push-Location $PSScriptRoot
try {
    New-Item -ItemType Directory -Path $assetsPath -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'index.html') -Destination (Join-Path $assetsPath 'index.html') -Force

    & npx.cmd --yes wrangler@4 whoami
    if ($LASTEXITCODE -ne 0) {
        throw 'Wrangler is not authenticated. Run: npx.cmd --yes wrangler@4 login --use-keyring'
    }

    $deployArgs = @('--yes', 'wrangler@4', 'pages', 'deploy', $assetsPath, '--project-name', $ProjectName)
    & npx.cmd @deployArgs
    if ($LASTEXITCODE -ne 0) {
        throw 'Cloudflare Pages deployment failed.'
    }
}
finally {
    if (Test-Path -LiteralPath $assetsPath) {
        Remove-Item -LiteralPath $assetsPath -Recurse -Force
    }
    Pop-Location
}
