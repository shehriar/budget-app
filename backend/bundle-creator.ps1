param(
  [Parameter(Mandatory = $true)]
  [string]$BundleName
)

$ErrorActionPreference = "Stop"

function Write-NoBom {
  param([string]$Path,[string]$Content)
  $enc = New-Object System.Text.UTF8Encoding($false)
  [IO.File]::WriteAllText($Path, $Content, $enc)
}

# ---- Locate backend root (no -and) ----
$backendDir = $null
if (Test-Path -LiteralPath ".\backend\pom.xml") {
  $backendDir = (Resolve-Path ".\backend").Path
} else {
  if (Test-Path -LiteralPath ".\pom.xml") {
    if (Test-Path -LiteralPath ".\src\main\java") {
      $backendDir = (Resolve-Path ".").Path
    }
  }
}
if (-not $backendDir) {
  throw "Could not find backend. Run this from project root (with .\backend\pom.xml) or inside backend/."
}

# ---- Find base package from *Application.java ----
$javaSrc = Join-Path $backendDir "src\main\java"
if (!(Test-Path -LiteralPath $javaSrc)) { throw "Missing source folder: $javaSrc" }

$appFile = Get-ChildItem -Path $javaSrc -Recurse -Filter "*Application.java" | Select-Object -First 1
if (-not $appFile) { throw "Could not find *Application.java under $javaSrc." }

$pkgLine = (Get-Content -Raw -LiteralPath $appFile.FullName) -split "`r?`n" |
  Where-Object { $_ -match '^\s*package\s+[\w\.]+;' } | Select-Object -First 1
if (-not $pkgLine) { throw "Could not parse package from $($appFile.FullName)." }

$basePackage = ($pkgLine -replace '^\s*package\s+','' -replace ';\s*$','').Trim()

# ---- Normalize names ----
# Bundle package segment (always lowercase + "bundle" suffix)
$normalized = ($BundleName -replace '[^A-Za-z0-9_]','').ToLower()
$bundlePkg = $normalized + "bundle"

if ([string]::IsNullOrWhiteSpace($normalized)) {
  throw "Bundle name '$BundleName' is invalid after normalization."
}

# PascalCase for class names (with "Bundle" suffix too)
function To-Pascal([string]$s) {
  ($s -split '[^A-Za-z0-9]+' | Where-Object {$_ -ne ""} |
    ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower() }) -join ''
}
$bundleClass = (To-Pascal $BundleName) + "Bundle"

# ---- Make directories ----
$pkgPath      = ($basePackage -replace '\.','\')
$bundleRoot   = Join-Path $javaSrc (Join-Path $pkgPath $bundlePkg)
$controllerDir= Join-Path $bundleRoot "controller"
$serviceDir   = Join-Path $bundleRoot "service"
$repoDir      = Join-Path $bundleRoot "repository"
$modelDir     = Join-Path $bundleRoot "model"

foreach ($d in @($bundleRoot,$controllerDir,$serviceDir,$repoDir,$modelDir)) {
  New-Item -ItemType Directory -Force -Path $d | Out-Null
}

# ---- Templates ----
$controllerCode = @"
package $basePackage.$bundlePkg.controller;

import $basePackage.$bundlePkg.service.${bundleClass}Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
@RequestMapping("/api/$bundlePkg")
public class ${bundleClass}Controller {
    private final ${bundleClass}Service service;

    public ${bundleClass}Controller(${bundleClass}Service service) {
        this.service = service;
    }

    @GetMapping("/ping")
    public Map<String, String> ping() {
        return Map.of("bundle", "$bundlePkg", "status", "ok");
    }
}
"@

$serviceCode = @"
package $basePackage.$bundlePkg.service;

import org.springframework.stereotype.Service;

@Service
public class ${bundleClass}Service {
    // TODO: business logic
}
"@

$repoCode = @"
package $basePackage.$bundlePkg.repository;

// Placeholder repository. Replace with Spring Data when ready, e.g.:
// public interface ${bundleClass}Repository extends org.springframework.data.jpa.repository.JpaRepository<YourEntity, Long> {}
public interface ${bundleClass}Repository {
    // TODO
}
"@

$modelCode = @"
package $basePackage.$bundlePkg.model;

// Placeholder model/DTO. Replace with real classes.
public class ${bundleClass}Model {
    private Long id;
    private String name;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}
"@

# ---- Write files (UTF-8 no BOM) ----
$controllerPath = Join-Path $controllerDir "${bundleClass}Controller.java"
$servicePath    = Join-Path $serviceDir    "${bundleClass}Service.java"
$repoPath       = Join-Path $repoDir       "${bundleClass}Repository.java"
$modelPath      = Join-Path $modelDir      "${bundleClass}Model.java"

Write-NoBom -Path $controllerPath -Content $controllerCode
Write-NoBom -Path $servicePath    -Content $serviceCode
Write-NoBom -Path $repoPath       -Content $repoCode
Write-NoBom -Path $modelPath      -Content $modelCode

Write-Host ""
Write-Host "✅ Created bundle '$BundleName' under package $basePackage.$bundlePkg"
Write-Host "   Controller: $controllerPath"
Write-Host "   Service:    $servicePath"
Write-Host "   Repository: $repoPath"
Write-Host "   Model:      $modelPath"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1) Build/run:  cd `"$backendDir`" ; .\mvnw spring-boot:run"
Write-Host "  2) Test:       curl http://localhost:8080/api/$bundlePkg/ping"
Write-Host "                 -> {`"bundle`":`"$bundlePkg`",`"status`":`"ok`"}"
