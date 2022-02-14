echo "install tools and dependencies"
echo "Begining..."
apk update -qq
apk add nano git -qq
git clone https://github.com/fetzu/teslamate-abrp.git /teslamate-abrp
pip install --no-cache-dir -r /teslamate-abrp/requirements.txt
echo "Done."