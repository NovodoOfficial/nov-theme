#!/bin/bash

echo "Publishing theme locally..."

# Define the pattern for the VSIX file
VSIX_PATTERN="nov-theme-*.vsix"

# Step 1: Delete old VSIX files if they exist
if ls $VSIX_PATTERN 1> /dev/null 2>&1; then
    rm $VSIX_PATTERN
    echo "All old VSIX files have been deleted."
else
    echo "No old VSIX files found."
fi

# Step 2: Create a new VSIX file
echo "Creating new VSIX file..."
vsce package

# Step 3: Uninstall the existing extension (if already installed), suppress errors
echo "Uninstalling the old theme extension (if exists)..."
EXTENSION_ID="novodoofficial.nov-theme"  # Ensure this is correct (publisher.extension-name)
code --uninstall-extension $EXTENSION_ID || echo "Extension $EXTENSION_ID is not installed or error occurred."

# Step 4: Install the new extension

# Find the newly created VSIX file using absolute path
NEW_VSIX_FILE=$(find "$(pwd)" -type f -name "nov-theme-*.vsix")

# Check if the VSIX file is found and install it
if [ -f "$NEW_VSIX_FILE" ]; then
    echo "Installing the new theme extension from $NEW_VSIX_FILE..."
    code --install-extension "$NEW_VSIX_FILE" || echo "Failed to install extension from VSIX file."
    echo "New VSIX extension installed successfully."
else
    echo "VSIX file not found for installation."
fi

# Step 5: Install additional icons
echo "Installing additional icon theme (LeonN534.dark-minimalist-icons)..."
code --install-extension LeonN534.dark-minimalist-icons || echo "Failed to install the icon theme."
echo "Additional icon theme installed successfully."

echo "Done!"
