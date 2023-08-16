if [ -d "/teslamate-abrp" ]; then
    # If exists just update
    echo "Updating repository..."
    git -C /teslamate-abrp pull
else # if not pull for the first time
    echo "Getting repository for the firstime..."
    git clone --branch $GIT_BRANCH https://github.com/jheredianet/teslamate-abrp.git /teslamate-abrp
    pip install --quiet --no-color --no-cache-dir -r /teslamate-abrp/requirements.txt
fi
echo "Running daemon..."
python -u /teslamate-abrp/teslamate_mqtt2abrp.py -a
