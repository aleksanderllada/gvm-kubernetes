VERSION?=v20.8.0

# Install PDFLatex on gvmd (might increase the size of the image by hundreds of Mbs)
INSTALL_PDFLATEX?=yes

# Pre-install NVT and Feed data. Must be updated from time to time regardless, using a cronjob.
RUN_NVT_SYNC?=no
RUN_FEED_SYNC?=no

.DEFAULT_GOAL := all

all: build push

build: base gsad gvmd ospd-openvas

push:
	docker push aleksanderllada/gvm-base:${VERSION}
	docker push aleksanderllada/gvm-gsad:${VERSION}
	docker push aleksanderllada/gvm-gvmd-base:${VERSION}
	docker push aleksanderllada/gvm-gvmd:${VERSION}
	docker push aleksanderllada/gvm-gvmd-postgres:${VERSION}
	docker push aleksanderllada/gvm-ospd-openvas:${VERSION}

base:
	docker build . -f dockerfiles/Dockerfile.base --build-arg VERSION=${VERSION} -t aleksanderllada/gvm-base:${VERSION}

gsad:
	docker build . -f dockerfiles/Dockerfile.gsad --build-arg VERSION=${VERSION} -t aleksanderllada/gvm-gsad:${VERSION}

gvmd-base:
	docker build . -f dockerfiles/Dockerfile.gvmd-base --build-arg VERSION=${VERSION} -t aleksanderllada/gvm-gvmd-base:${VERSION}

gvmd-postgres: gvmd-base
	docker build . -f dockerfiles/Dockerfile.gvmd-postgres --build-arg VERSION=${VERSION} --build-arg INSTALL_PDFLATEX=${INSTALL_PDFLATEX} -t aleksanderllada/gvm-gvmd-postgres:${VERSION}

gvmd: gvmd-base gvmd-postgres
	docker build . -f dockerfiles/Dockerfile.gvmd --build-arg VERSION=${VERSION} --build-arg INSTALL_PDFLATEX=${INSTALL_PDFLATEX} --build-arg RUN_FEED_SYNC=${RUN_FEED_SYNC} -t aleksanderllada/gvm-gvmd:${VERSION}

ospd-openvas:
	docker build . -f dockerfiles/Dockerfile.ospd-openvas --build-arg VERSION=${VERSION} --build-arg RUN_NVT_SYNC=${RUN_NVT_SYNC} -t aleksanderllada/gvm-ospd-openvas:${VERSION}
