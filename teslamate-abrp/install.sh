echo "install tools and dependencies"
echo "Begining..."
apk update -qq
apk add nano git -qq
#git clone https://github.com/fetzu/teslamate-abrp.git /teslamate-abrp
#git clone https://github.com/letienne/teslamate-abrp.git /teslamate-abrp
git clone --branch feature_moderatedtime https://github.com/jheredianet/teslamate-abrp.git /teslamate-abrp
python -m pip install --upgrade pip
pip install --no-cache-dir -r /teslamate-abrp/requirements.txt
pip install psycopg2-binary
echo "Done."