rm -rf resources/ public/ .hugo_build.lock
git add .
git commit -m "update"
git push
sleep 3s
echo "Done!"
sleep 3s
