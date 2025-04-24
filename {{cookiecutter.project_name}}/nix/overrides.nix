# Define package overrides to handle problematic dependencies
{ pkgs }:

{
  # Disable commitizen if it's causing issues
  # commitizen = null;

  # Example: replace a package with a working version or placeholder
  # black = pkgs.writeShellScriptBin "black" ''
  #   echo "Using placeholder black formatter"
  #   exit 0
  # '';
}
