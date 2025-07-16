############################################################
# Calculates and displays the number of days until 2045
# Add this to your ~/.bashrc or ~/.zshrc file
############################################################

# Get the target date (Jan 1, 2045) in seconds since the epoch
# The command syntax is different for Linux (GNU) and macOS/BSD.
if date --version >/dev/null 2>&1; then
  # GNU 'date' (common on Linux)
  TARGET_DATE_SECONDS=$(date -d "2045-01-01" +%s)
else
  # BSD 'date' (common on macOS)
  TARGET_DATE_SECONDS=$(date -j -f "%Y-%m-%d" "2045-01-01" "+%s")
fi

# Get the current date in seconds since the epoch
CURRENT_DATE_SECONDS=$(date +%s)

# Calculate the difference in seconds and then convert to days
# 86400 seconds in a day (60 * 60 * 24)
SECONDS_REMAINING=$((TARGET_DATE_SECONDS - CURRENT_DATE_SECONDS))
DAYS_REMAINING=$((SECONDS_REMAINING / 86400))

# Format the number with a dot as a thousands separator
# 'printf' with "'" uses the system's locale to format the number (e.g., 7,122).
# 'sed' then replaces the comma with a dot to match your requested format.
FORMATTED_DAYS=$(printf "%'d" $DAYS_REMAINING | sed 's/,/./g')

# Display the final message
echo ""  # So there's space before the massage (aesthetical purpose)
echo "${FORMATTED_DAYS} hari lagi menuju Indonesia Emas 2045"
echo ""  #another space lmfao
# echo "${FORMATTED_DAYS} left till we reach the Golden Indonesia 2045"  // If you want english
