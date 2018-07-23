# DNA Subway Green Line

This is the current implementation of the [DNA Subway](https://dnasubway.cyverse.org) Green Line. The app catalog is implemented as [Agave API](https://agaveapi.com) applications based on [Docker](https://docker.com) containers. The apps are [kallisto](http://pachterlab.github.io/kallisto/)/[sleuth](http://pachterlab.github.io/sleuth/) for quantification and differential analysis, and the [Tuxedo 2 suite](https://www.nature.com/articles/nprot.2016.095) for novel splice sites discovery. 

The repository is organized as follows:
.
├── kallisto\_sleuth
│   ├── app-gl-ks.json
│   ├── app-gl-ks-stampede2.json
│   ├── docker
│   │   ├── cleanup.sh
│   │   ├── default\_entrypoint.sh
│   │   ├── Dockerfile
│   │   ├── run-kallisto.sh
│   │   ├── run-ks.sh
│   │   ├── run-sleuth.r
│   │   └── sleuth\_install.r
│   ├── test-ks.sh
│   ├── test-ks-stampede2.sh
│   ├── wrap-gl-ks.sh
│   └── wrap-gl-ks-stampede2.sh
├── README.md
└── tuxedo2
    ├── docker
    │   ├── default_entrypoint.sh
    │   ├── Dockerfile
    │   ├── install-ballgown.r
    │   ├── run-ballgown.r
    │   ├── run-hisat2.sh
    │   ├── run-stringtie.sh
    │   └── run-tuxedo2.sh
    └── test-tuxedo2.sh

### Converting docker image to Singularity
To run this workflow in some HPC environments such as [Stampede2](https://www.tacc.utexas.edu/systems/stampede2), [Singularity](https://www.sylabs.io/guides/2.5.1/user-guide/introduction.html) must be used. Fortunately, it is possible to easily convert our Docker image to a Singularity one. This works with Docker version 1.6.0 or higher and Singularity 2.5.2

Start by running a local registry. We will use this registry to push the Docker image. 
```
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```
Then, if you haven't done so, build the Docker image.
```
docker build -t image_name .
```
Next, tag the newly built image and push it to the local registry.
```
docker tag image_name localhost:5000/image_name
docker push localhost:5000/image_name
```
If you want to test pulling the image from the local registry, you can delete `image_name` and `localhost:5000/image_name` and then pull `localhost:5000/image_name` from the registry.
```
docker pull localhost:5000/image_name
```

To build the Singularity image, run
```
SINGULARITY_NOHTTPS=true singularity build singularity_image_name.simg docker://localhost:5000/image_name
```

You can test the image to see if it was built successfully by running
```
singularity run singularity_image_name.simg
```

Finally, if you wish to stop the registry and remove it, run
```
docker container stop registry
docker container rm -v registry
```
