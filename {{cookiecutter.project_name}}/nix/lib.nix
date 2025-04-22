# Core utility functions for package management
{
  # Safely import a file with fallback
  safeImport =
    path: args: default:
    if builtins.pathExists path then import path args else default;

  # Try to get a package, with fallback if it fails
  tryPackage =
    pkgs: name:
    let
      result = builtins.tryEval (pkgs.${name} or null);
    in
    if result.success && result.value != null then result.value else null;

  # Merge package sets, filtering out nulls
  mergePackages =
    sets:
    let
      combined = builtins.foldl' (acc: set: acc // set) { } sets;
      filtered = builtins.removeAttrs combined (
        builtins.filter (name: combined.${name} == null) (builtins.attrNames combined)
      );
    in
    filtered;

  # Convert an attrset of packages to a list, filtering out nulls
  packagesToList = packages: builtins.filter (p: p != null) (builtins.attrValues packages);
}
