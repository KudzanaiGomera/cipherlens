param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

Push-Location $PSScriptRoot
try {
    if (-not $DryRun) {
        & npx.cmd --yes wrangler@4 whoami
        if ($LASTEXITCODE -ne 0) {
            throw 'Wrangler is not authenticated. Run: npx.cmd --yes wrangler@4 login --use-keyring'
        }
    }

    $deployArgs = @('--yes', 'wrangler@4', 'deploy', '--config', (Join-Path $PSScriptRoot 'wrangler.jsonc'))
    if ($DryRun) {
        $deployArgs += '--dry-run'
    }

    & npx.cmd @deployArgs
    if ($LASTEXITCODE -ne 0) {
        throw 'Cloudflare deployment failed.'
    }
}
finally {
    Pop-Location
}
