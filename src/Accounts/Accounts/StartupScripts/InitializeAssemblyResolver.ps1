﻿[Microsoft.Azure.PowerShell.AssemblyLoading.ConditionalAssemblyCollection]::Initialize(
  [Microsoft.Azure.PowerShell.AssemblyLoading.ConditionalAssemblyBuilderContext]::new($Host.Version)
)

if ($PSEdition -eq 'Desktop') {
  try {
    [Microsoft.Azure.Commands.Profile.Utilities.CustomAssemblyResolver]::Initialize()
  }
  catch {
    Write-Warning $_
  }
}
else {
  try {
    Add-Type -Path ([System.IO.Path]::Combine($PSScriptRoot, "..", "Microsoft.Azure.PowerShell.AuthenticationAssemblyLoadContext.dll")) | Out-Null
    $assemblyLoadContextFolder = [System.IO.Path]::Combine($PSScriptRoot, "..", "lib")
    Write-Debug "Registering Az shared AssemblyLoadContext for path: '$assemblyLoadContextFolder'."
    [Microsoft.Azure.PowerShell.AuthenticationAssemblyLoadContext.AzAssemblyLoadContextInitializer]::RegisterAzSharedAssemblyLoadContext($assemblyLoadContextFolder)
    Write-Debug "AssemblyLoadContext registered."
  }
  catch {
    Write-Warning $_
  }
}