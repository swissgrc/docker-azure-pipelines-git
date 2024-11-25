# Docker image for running Git in an Azure Pipelines container job

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-git/blob/main/LICENSE) [![Build](https://img.shields.io/github/actions/workflow/status/swissgrc/docker-azure-pipelines-git/publish.yml?branch=develop&style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-git/actions/workflows/publish.yml) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=swissgrc_docker-azure-pipelines-git&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=swissgrc_docker-azure-pipelines-git) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-git.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-git) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-git.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-git)
<!-- markdownlint-restore -->

Docker image to run Git in [Azure Pipelines container jobs].
The image contains also Docker CLI to access Docker engine on the agent.

## Usage

This image can be used to run Git in [Azure Pipelines container jobs].

### Azure Pipelines Container Job

To use the image in an Azure Pipelines Container Job, add one of the following example tasks and use it with the `container` property.

The following example shows the container used for a deployment step which shows Git version:

```yaml
  - stage: deploy
    jobs:
      - deployment: runGit
        container: swissgrc/azure-pipelines-git:latest
        environment: smarthotel-dev
        strategy:
          runOnce:
            deploy:
              steps:
                - bash: |
                    git version
```

### Tags

| Tag        | Description                                                                                     | Base Image                       | Git                  | Git LFS | Size                                                                                                                         |
|------------|-------------------------------------------------------------------------------------------------|----------------------------------|----------------------|---------|------------------------------------------------------------------------------------------------------------------------------|
| latest     | Latest stable release (from `main` branch)                                                      | azure-pipelines-dockercli:27.3.1 | 2.47.0               | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/latest?style=flat-square)   |
| unstable   | Latest unstable release (from `develop` branch)                                                 | azure-pipelines-dockercli:27.3.1 | 2.47.1               | 3.6.0   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/unstable?style=flat-square) |
| 2.39.2     | [Git 2.39.2](https://github.com/git/git/blob/master/Documentation/RelNotes/2.39.2.txt)          | azure-pipelines-dockercli:24.0.0 | 1:2.39.2-1~bpo11+1   | 3.3.0   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.39.2?style=flat-square)   |
| 2.42.0     | [Git 2.42.0](https://github.com/git/git/blob/master/Documentation/RelNotes/2.42.0.txt)          | azure-pipelines-dockercli:24.0.6 | 2.42.0               | 3.4.0   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.42.0?style=flat-square)   |
| 2.42.1     | [Git 2.42.1](https://github.com/git/git/blob/master/Documentation/RelNotes/2.42.1.txt)          | azure-pipelines-dockercli:24.0.7 | 2.42.1               | 3.4.0   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.42.1?style=flat-square)   |
| 2.43.0     | [Git 2.43.0](https://github.com/git/git/blob/master/Documentation/RelNotes/2.43.0.txt)          | azure-pipelines-dockercli:24.0.7 | 2.43.0               | 3.4.0   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.43.0?style=flat-square)   |
| 2.43.1     | [Git 2.43.1](https://github.com/git/git/blob/master/Documentation/RelNotes/2.43.1.txt)          | azure-pipelines-dockercli:25.0.3 | 2.43.1               | 3.4.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.43.1?style=flat-square)   |
| 2.43.2     | [Git 2.43.2](https://github.com/git/git/blob/master/Documentation/RelNotes/2.43.2.txt)          | azure-pipelines-dockercli:25.0.3 | 2.43.2               | 3.4.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.43.2?style=flat-square)   |
| 2.44.0     | [Git 2.44.0](https://github.com/git/git/blob/master/Documentation/RelNotes/2.44.0.txt)          | azure-pipelines-dockercli:25.0.4 | 2.44.0               | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.44.0?style=flat-square)   |
| 2.45.0     | [Git 2.45.0](https://github.com/git/git/blob/master/Documentation/RelNotes/2.45.0.txt)          | azure-pipelines-dockercli:26.1.1 | 2.45.0               | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.45.0?style=flat-square)   |
| 2.45.1     | [Git 2.45.1](https://github.com/git/git/blob/master/Documentation/RelNotes/2.45.1.txt)          | azure-pipelines-dockercli:26.1.2 | 2.45.1               | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.45.1?style=flat-square)   |
| 2.45.2     | [Git 2.45.2](https://github.com/git/git/blob/master/Documentation/RelNotes/2.45.2.txt)          | azure-pipelines-dockercli:26.1.3 | 2.45.2               | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.45.2?style=flat-square)   |
| 2.46.0     | [Git 2.46.0](https://github.com/git/git/blob/master/Documentation/RelNotes/2.46.0.txt)          | azure-pipelines-dockercli:27.1.1 | 2.46.0               | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.46.0?style=flat-square)   |
| 2.46.1     | [Git 2.46.1](https://github.com/git/git/blob/master/Documentation/RelNotes/2.46.1.txt)          | azure-pipelines-dockercli:27.2.1 | 2.46.1               | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.46.1?style=flat-square)   |
| 2.46.2     | [Git 2.46.2](https://github.com/git/git/blob/master/Documentation/RelNotes/2.46.2.txt)          | azure-pipelines-dockercli:27.3.1 | 2.46.2               | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.46.2?style=flat-square)   |
| 2.47.0     | [Git 2.47.0](https://github.com/git/git/blob/master/Documentation/RelNotes/2.47.0.txt)          | azure-pipelines-dockercli:27.3.1 | 2.47.0               | 3.5.1   | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-git/2.47.0?style=flat-square)   |

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
