Docker Workshop
===============

```bash
git clone git@gitlab.socrate.vsct.fr:jeanpascal_thiery/docker-techevent.git
cd docker-techevent
git checkout vsct
docker run --rm --label=jekyll --volume=$(pwd):/srv/jekyll -it -p 4000:4000 jekyll/jekyll:pages jekyll server  --watch 
```

