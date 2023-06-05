# composesync

composesync makes it simple to synchronize all the images used in a Docker
Compose file to one or more destination Docker registries. All interaction
with docker registries is done by
[regsync](https://github.com/regclient/regclient/).

Using Docker Compose files as manifests of what to copy has the advantage of
tools such as Renovate supporting update maintenance out of the box.

## Usage

1.  Populate a Docker Compose yaml file with services that reference images.

    You can specify a name for the image to be synced to. By default, the 
    target name will be the same as the source with the registry hostname
    removed.

    ```yaml
    services:
      service-name-does-not-matter:
        image: "gcr.io/distroless/python3-debian11:nonroot@sha256:cc7021d6bd5aae9cdd976ae4b185cc59d5792b18aa5e18345dbf9b34d6b3f5a0"
        x-composesync-name: "python3"
    ```
    
2.  If any registry authentication configuration is required, create a 
    [regsync configuration file](https://github.com/regclient/regclient/blob/main/docs/regsync.md#configuration-file)
    and specify it with the `--regsync-config=` flag. The `creds` section will be copied from this file.

    ```yaml
    creds:
    - registry: gcr.io
      repoAuth: true
      credHelper: docker-credential-gcr
    - registry: us-west1-docker.pkg.dev
      repoAuth: true
      credHelper: docker-credential-gcr
    ```

3.  Run composesync as a container in a CICD workflow.

    For local testing, you can mount in your Google Cloud configuration 
    as a read-only volume to allow `docker-credential-gcr` to find your 
    "application default credentials" populated via
    `gcloud auth login --update-adc`.

    ```shell
    docker run -it --rm \
    --volume $HOME/.config/gcloud:/home/appuser/.config/gcloud:ro \
    --volume `pwd`/example:/example:ro \
    retailnext/composesync \
    --regsync-config /example/regsync.yaml \
    /example/compose.yaml \
    us-west1-docker.pkg.dev/your-project/your-destination-artifact-registry
    ```

## Project Status

We use this internally. It _may_ receive some publicly-visible maintenance,
but it is not a priority for us. We may make breaking changes without warning.

## Contributing

Contributions considered, but be aware that this is mostly just something we
needed. It's public because there's no reason anyone else should have to waste
an afternoon (or more) building something similar, and we think the approach
is good enough that others would benefit from adopting.

This project is licensed under the [Apache License, Version 2.0](LICENSE).

Please include a `Signed-off-by` in all commits, per
[Developer Certificate of Origin version 1.1](DCO).
