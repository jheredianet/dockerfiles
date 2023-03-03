echo "install tools and dependencies"
echo "Begining..."
apk update -qq
apk add nano git -qq
python -m pip install --upgrade pip
pip install --no-cache-dir -r /teslamate-abrp/requirements.txt
pip install psycopg2-binary
echo "Done."