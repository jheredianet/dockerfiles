cd /teslamate-abrp
echo "Updating repository..."
git pull
echo "Running daemon..."
python -u ./teslamate_mqtt2abrp.py -a

