#!/bin/bash

read -p "Enter new assignment name: " newAssignment

# Use sed to replace ASSIGNMENT value in config.env
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$newAssignment\"/" ./config/config.env

echo "Assignment updated to: $newAssignment"
echo "----------------------------------------"
./startup.sh
