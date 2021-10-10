# For building you have to be on the root of the repository and run 
# Don't forget to update this version
VERSION="2.0"
docker build -t juanheredia/jenkins:$VERSION -f jenkins/Dockerfile .

# Then push to hub
docker push juanheredia/jenkins:$VERSION

# Rename to latest
docker tag juanheredia/jenkins:$VERSION juanheredia/jenkins

# Then push latest to hub
docker push juanheredia/jenkins