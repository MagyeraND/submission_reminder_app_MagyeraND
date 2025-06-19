#!/bin/bash

# Prompt for user's name

read -p "Enter your name: " userName
appDir="submission_reminder_${userName}"

# Create directory structure

mkdir -p "${appDir}/config"
mkdir -p "${appDir}/modules"
mkdir -p "${appDir}/assets"

# Create and populate config/config.env

cat <<EOL > "${appDir}/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

# Create and populate modules/functions.sh

cat <<'EOL' > "${appDir}/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted

function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines

    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOL

# Create and populate reminder.sh
cat <<'EOL' > "${appDir}/reminder.sh"
#!/bin/bash

source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOL

# Create and populate assets/submissions.txt

cat <<EOL > "${appDir}/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Zawadi, Shell Navigation, not submitted
Emile, Git, not submitted
Ishimwe, Shell Navigation, submitted
Liam, Git, submitted
Ethan, Shell Basics, not submitted
EOL

# Create and populate startup.sh

cat <<'EOL' > "${appDir}/startup.sh"
#!/bin/bash

echo "Starting submission reminder app..."
./reminder.sh
EOL

# Make all .sh scripts executable

find "${appDir}" -type f -name "*.sh" -exec chmod +x {} \;

echo "Environment setup complete in directory: $appDir"

