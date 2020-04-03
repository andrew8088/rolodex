#! /bin/sh

# symlinks the .tfvar and .tfstate files from icloud

if [ ! -d "$(pwd)/infrastructure" ]
then
    echo "no 'infrastructure' dir, are you in the project root?"
    exit 1
fi

if [ -z ${ICLOUD_PATH+x} ]
then
    echo "no ICLOUD_PATH; exiting"
    exit 1
fi

REMOTE_DIR="$ICLOUD_PATH/code/rolodex-terraform"

for filename in "$REMOTE_DIR"/*.{tfvars,tfstate*}; do
    ln -s "$filename" "$(pwd)/infrastructure/$(basename "$filename")"
    echo "symlinked $(basename "$filename")"
done